# Tracker

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tracker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tracker

## Usage

console.

```ruby
bundle exec bin/tracker trace -n 123412341231 -c sagawa
> # return json text
```

options -c [yamato|sagawa|yuusei|seinou]


rails etc.

```ruby
def index
  str = Tracker::Base.execute no: "123412341231", company: "sagawa"
  ary = JSON.parse(str)
end
```

multiple search.

```ruby
str = Tracker::Base.execute no: "123412341231"
ary = JSON.parse(str)
```

generate document.

```ruby
(gem install yard)
yardoc lib/*
open lib/index.html
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tracker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
