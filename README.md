# Ibge

[![Build Status](https://travis-ci.org/brunoarueira/ibge.svg?branch=master)](https://travis-ci.org/brunoarueira/ibge)
[![Code Climate](https://codeclimate.com/github/brunoarueira/ibge/badges/gpa.svg)](https://codeclimate.com/github/brunoarueira/ibge)

Unofficial gem with a bunch of data collected by IBGE. The data collected are responsibility of IBGE (Instituto Brasileiro de Geografia e Estatística, in english Brazilian Institute of Geography and Statistics) and this gem makes an integration with ruby more easy.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ibge'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ibge

## Usage

For now, the gem supports 6 types of information: State (without abbreviation yet), Meso region, Micro region, Municipality, District and Sub district.

To read any type, the readers has the same API like below:

```ruby
  # For state
  Ibge::Reader::State.read #=> [{ code: '11', state_name: 'Rondônia' }, ... { code: '53', state_name: 'Distrito Federal' }]

  # For municipality
  Ibge::Reader::Municipality.read #=> [{:state_code=>"11", :meso_region_code=>"01", :micro_region_code=>"001", :code=>"00205", :full_code=>"1100205", :name=>"Porto Velho"},
                                       ...,
                                       {:state_code=>"53", :meso_region_code=>"01", :micro_region_code=>"001", :code=>"00108", :full_code=>"5300108", :name=>"Brasília"}]
```

## Maintainer

- Bruno Arueira

## Contributing

1. Fork it ( https://github.com/[my-github-username]/ibge/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
