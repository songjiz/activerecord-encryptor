# ActiveRecord::Encryptor

[![Build Status](https://travis-ci.com/songjiz/activerecord-encryptor.svg?branch=master)](https://travis-ci.com/songjiz/activerecord-encryptor)

Encrypt attributes with ActiveSupport::MessageEncryptor and ActiveRecord::Attributes API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-encryptor'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install activerecord-encryptor

## Usage

```ruby
ActiveRecord::Schema.define(version: 2020_09_16_154202) do

  create_table "users", force: :cascade do |t|
    t.text "pub_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
```

```ruby
class User < ApplicationRecord
  encrypted_attribute :pub_key, :text
end
```

```ruby
user = User.new
user.pub_key = "ruby"

user.save
#  (0.1ms)  begin transaction
#  User Update (0.4ms)  UPDATE "users" SET "pub_key" = ?, "updated_at" = ? WHERE "users"."id" = ?  [["pub_key", "UjlTT0xWWkVoSXVTekYvR3ZuQjVJZz09LS1jMjJqL2JlRUl5UlFhcFVLSk5JNVZ3PT0=--8a0629d448118e61cc8d21f643ae4875f8fc929319c31f5a3b30fdf7f0920f62"], ["updated_at", "2020-09-29 10:54:42.067929"], ["id", 1]]
#  (2.2ms)  commit transaction
#  => true

user.reload
user.pub_key # => "ruby"

user.pub_key = nil
user.save
#   (0.1ms)  begin transaction
#   User Update (0.4ms)  UPDATE "users" SET "pub_key" = ?, "updated_at" = ? WHERE "users"."id" = ?  [["pub_key", nil], ["updated_at", "2020-09-29 10:56:10.167344"], ["id", 1]]
#   (2.4ms)  commit transaction
#  => true
user.reload
user.pub_key # => nil

user.pub_key = "rails"
user.save
#   (0.1ms)  begin transaction
#   User Update (0.4ms)  UPDATE "users" SET "pub_key" = ?, "updated_at" = ? WHERE "users"."id" = ?  [["pub_key", "RGM4eC9USE80bDk3N1BrSUdOaDZUZz09LS1VT016ckhHUVJUbVdsSncyNkRMNEd3PT0=--988267203a47d39ef991af785f3d381bbc10afe1dd92de3244d8eba1acf34697"], ["updated_at", "2020-09-29 10:58:54.283360"], ["id", 1]]
#   (2.6ms)  commit transaction
# => true
```

```ruby
class User < ApplicationRecord
  encrypted_attribute :pub_key, :text,
                 secret: Rails.application.key_generator.generate_key('user/pub_key', ActiveSupport::MessageEncryptor.key_len),
                 cipher: 'aes-256-cbc',
                 digest: 'SHA256',
                 rotations: [
                   { secret: encryptor_secret, cipher: 'aes-256-gcm', digest: 'SHA1' }
                 ]
end

user = User.find(1)
user.pub_key # => "rails"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/songjiz/activerecord-encryptor.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
