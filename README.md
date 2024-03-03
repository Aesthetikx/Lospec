# Lospec

This gem is a simple interface to the color palettes available on lospec.com.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add lospec

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install lospec

## Usage

Use `Lospec::Palette.search` to search for palettes. For example, to find a palette with four colors:
```ruby
palette = Lospec::Palette.search(colors: 4).first

palette.slug   # => "tropical-fruit-04"
palette.colors # => ["f5b413", "9c1904", "dd0956", "250442"]
```

You can also sort by most downloads first, and specify an endless range for colors. The available sort options are `:default`, `:alphabetical`, `:downloads`, and `:newest`.
```ruby
palette = Lospec::Palette.search(colors: ..3, tag: 'black', sort: :downloads).first

palette.title  # => "1bit Monitor Glow"
palette.colors # => ["222323", "f0f6f0"]
```

The search method returns a lazy enumerable, so you can filter and limit. For example, to find up to three popular palettes with four or more colors containing pure white:
```ruby
palettes = Lospec::Palette
  .search(colors: 4.., sort: :downloads)
  .filter { |palette| palette.colors.include?("ffffff") }
  .take(3)
  .to_a

palettes.map(&:slug) # => ["2-bit-grayscale", "arq4", "cga-palette-1-high"]
```

If you know the slug of a specific palette, you can fetch it directly:
```ruby
palette = Lospec::Palette.fetch("nintendo-gameboy-bgb")

palette.description # => "The default palette used by the bgb emulator..."
```

## Considerations

Lospec does provide an API, by which you can fetch the name and colors of a palette by slug. It does not provide a formal API to obtain the additional details of the palette, nor an API to search for palettes. Therefore, this gem is an interface that wraps network calls made by the lospec.com frontend. To mitigate needless network calls, this library employs request caching and lazy collections. However, do be aware that the methods in this gem do make network requests to lospec.com, so care should be used to limit excessive usage. Read more [here](https://lospec.com/palettes/api).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Aesthetikx/lospec.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
