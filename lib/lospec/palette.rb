# frozen_string_literal: true

module Lospec
  class PaletteNotFound < Error
    def initialize(slug)
      super("Palette not found: #{slug}")
    end
  end

  palette_attributes = %i[
    id
    slug
    title
    description
    colors
    tags
    hashtag
    published_at
    created_at
    downloads
    likes
    comments
  ]

  Palette = Data.define(*palette_attributes) do
    def self.fetch(slug)
      search = Lospec::Palette::Search.new(sort: :downloads)

      result = search.results.detect { |palette| palette.slug == slug }

      result or fail PaletteNotFound, slug
    end

    def self.search(...)
      Lospec::Palette::Search.new(...).results
    end
  end
end
