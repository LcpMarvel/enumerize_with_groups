# EnumerizeWithGroups

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/enumerize_with_groups`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'enumerize_with_groups'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install enumerize_with_groups

## Usage

```ruby
class ShoppingCart < ActiveRecord::Base
  extend Enumerize
  extend EnumerizeWithGroups # extend this module after `extend Enumerize`

  # define enumerize with groups
  enumerize :item,
            in: %i(banana apple football basketball),
            groups: {
              fruit: %i(banana apple),
              ball: %i(football basketball)
            }
end

ShoppingCart.item_groups  =>  # {
                              #   fruit: %i(banana apple),
                              #   ball: %i(football basketball)
                              # }

ShoppingCart.item_fruit   =>  # [:banana, :apple]

ShoppingCart.last.in_item_fruit?  => # true


# if you use `ActiveRecord::Base`
ShoppingCart.item_fruit_scope # ShoppingCart.where(item: %w(banana apple))

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/enumerize_with_groups. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

