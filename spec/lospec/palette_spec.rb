# frozen_string_literal: true

describe Lospec::Palette do
  describe "::fetch" do
    let(:slug) { "sweet-guarana" }

    let(:palette) { described_class.fetch slug }

    it "has an id" do
      expect(palette.id).to eq "5bb52e37d8f5345a507022b1"
    end

    it "has a slug" do
      expect(palette.slug).to eq "sweet-guarana"
    end

    it "has a title" do
      expect(palette.title).to eq "Sweet Guaraná"
    end

    it "has a description" do
      expect(palette.description).to eq "Created by <a target=\"_blank\" href=\"https://twitter.com/pezkoh/\">MadPezkoh</a>."
    end

    it "has colors" do
      expect(palette.colors).to eq %w[253b46 18865f 61d162 ebe7ad]
    end

    it "has tags" do
      expect(palette.tags).to eq %w[artist madpezkoh]
    end

    it "has a hashtag" do
      expect(palette.hashtag).to eq "sweetguarana"
    end

    it "has a published_at timestamp" do
      expect(palette.published_at).to eq Time.parse("2018-10-03T21:01:43.538Z")
    end

    it "has a created_at timestamp" do
      expect(palette.created_at).to eq Time.parse("2018-10-03T21:01:43.538Z")
    end

    it "has a count of downloads" do
      expect(palette.downloads).to eq 1440
    end

    it "has a count of likes" do
      expect(palette.likes).to eq 35
    end

    it "has a count of comments" do
      expect(palette.comments).to eq 10
    end
  end

  describe "::search" do
    let(:results) { described_class.search(**query) }

    let(:query) { { colors:, sort: :downloads } }

    let(:colors) { 4 }

    describe "a palette result" do
      subject(:palette) { results.first }

      it "has an id" do
        expect(palette.id).to eq "5a0de9e5e8a1031a12d039b7"
      end

      it "has a slug" do
        expect(palette.slug).to eq "kirokaze-gameboy"
      end

      it "has a title" do
        expect(palette.title).to eq "Kirokaze Gameboy"
      end

      it "has a description" do
        expect(palette.description).to eq ""
      end

      it "has colors" do
        expect(palette.colors).to eq %w[332c50 46878f 94e344 e2f3e4]
      end

      it "has tags" do
        expect(palette.tags).to eq %w[artist gameboy]
      end

      it "has a hashtag" do
        expect(palette.hashtag).to eq "kirokazegameboy"
      end

      it "has a published_at timestamp" do
        expect(palette.published_at).to eq Time.parse("2017-11-16T19:41:25.994Z")
      end

      it "has a created_at timestamp" do
        expect(palette.created_at).to eq Time.parse("2017-11-16T19:41:25.994Z")
      end

      it "has a count of downloads" do
        expect(palette.downloads).to eq 19_315
      end

      it "has a count of likes" do
        expect(palette.likes).to eq 637
      end

      it "has a count of comments" do
        expect(palette.comments).to eq 9
      end
    end

    describe "multiple pages" do
      subject(:palette) { results.take(40).to_a.last }

      it "finds the 40th palette" do
        expect(palette.slug).to eq "gb-chocolate"
      end
    end

    describe "a maximum color count" do
      subject(:palette) { results.first }

      let(:colors) { ..3 }

      it "finds palettes with 3 or fewer colors" do
        expect(palette.slug).to eq "1bit-monitor-glow"
      end
    end
  end
end
