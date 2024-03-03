# frozen_string_literal: true

require "json"
require "open-uri/cached"

module Lospec
  class Palette
    class Search
      SORT_TYPES = %i[default alphabetical downloads newest].freeze

      attr_reader :colors, :tag, :sort

      def initialize(colors: nil, tag: "", sort: :default)
        fail ArgumentError, "Sort should be one of #{SORT_TYPES}" unless SORT_TYPES.include?(sort.to_sym)

        @colors = colors
        @tag = tag
        @sort = sort
      end

      def results(&)
        return to_enum(:results).lazy unless block_given?

        (0..).lazy.each do |page| # : Numeric
          results = results_for_page(page:)

          results.each(&)

          break if results.empty?
        end
      end

      private

      def results_for_page(page:)
        url = url(page:)

        json = URI.open(url.to_s).read # : String

        data = JSON.parse(json)

        data["palettes"].map(&method(:parse))
      end

      def url(page: 0)
        host = "lospec.com"

        path = "/palette-list/load"

        params = {
          **colors_params,
          page:,
          tag:,
          sortingType: sort
        }

        query = URI.encode_www_form params

        URI::HTTPS.build(host:, path:, query:)
      end

      def colors_params # rubocop:disable Metrics
        if colors.nil?
          { colorNumberFilterType: "any" }
        elsif colors.is_a?(Range) && colors.begin && colors.end
          fail ArgumentError, "Range must be one sided"
        elsif colors.is_a?(Range) && colors.begin.nil?
          { colorNumberFilterType: "max", colorNumber: colors.end }
        elsif colors.is_a?(Range) && colors.end.nil?
          { colorNumberFilterType: "min", colorNumber: colors.begin }
        elsif colors.is_a?(Numeric)
          { colorNumberFilterType: "exact", colorNumber: colors }
        else
          fail ArgumentError, "Colors must be a number or one sided range"
        end
      end

      def parse(json) # rubocop:disable Metrics
        number = ->(n) { n.to_s.gsub(/[^0-9]/, "").to_i }

        timestamp = Time.method(:parse)

        Lospec::Palette.new(
          id: json["_id"],
          slug: json["slug"],
          title: json["title"],
          description: json["description"],
          colors: json["colors"],
          tags: json["tags"],
          hashtag: json["hashtag"],
          published_at: timestamp[json["publishedAt"]],
          created_at: timestamp[json["createdAt"]],
          downloads: number[json["downloads"]],
          likes: number[json["likes"]],
          comments: number[json["comments"]]
        )
      end
    end
  end
end
