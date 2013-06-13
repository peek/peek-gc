# Peek::GC

Take a peek into the GC info of your Rails application.

## Installation

Add this line to your application's Gemfile:

    gem 'peek-gc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install peek-gc

## Usage

Add the following to your `config/initializers/peek.rb`:

```ruby
Peek.into Peek::Views::Gc
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
