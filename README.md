# ActiveRecord::Encryptor

Native encrypted attributes for ActiveRecord with ActiveSupport::MessageEncryptor.

**But do not support search by the unencrypted value.** 👓

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-encryptor', github: 'https://github.com/songjiz/activerecord-encryptor'
```

And then execute:

    $ bundle install

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
  attr_encryptor :pub_key
end
```

```ruby
user = User.new
user.pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqvSdexJ11MpnL3IuFZo9d16VXpjSCqnsHusjmHLPslYCeOpAR5i166d
NpJKp0Mw94QeIoquoSd9eF5P0pYJvDts543FHdzIipQlkGijsuwoRna8u/2BoYljYoNc5bfxArYTviIoGuPh2z2GsPQY266fsGsq3ebuR6hpmJU1H6AfE4v2AIYnMh/
xA28qpZ1Yn6i4U4HSeaL6VpaVPlIyatVRD1QmQHHnENFnzR0uT3LMl9b8jLHmgHagRuppFycX4O5lh/d76+Dz9VlwMYKEaYRmUIpCtePff3CPZoBnwopz9PQ6mEsqx2
e3RfiRKUbSvtdBf+30fGmFXKNUY93 sandbox"

user.save
user.reload
user.pub_key # => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqvSdexJ11MpnL3IuFZo9d16VXpjSCqnsHusjmHLPslYCeOpAR5i166d
NpJKp0Mw94QeIoquoSd9eF5P0pYJvDts543FHdzIipQlkGijsuwoRna8u/2BoYljYoNc5bfxArYTviIoGuPh2z2GsPQY266fsGsq3ebuR6hpmJU1H6AfE4v2AIYnMh/
xA28qpZ1Yn6i4U4HSeaL6VpaVPlIyatVRD1QmQHHnENFnzR0uT3LMl9b8jLHmgHagRuppFycX4O5lh/d76+Dz9VlwMYKEaYRmUIpCtePff3CPZoBnwopz9PQ6mEsqx2
e3RfiRKUbSvtdBf+30fGmFXKNUY93 sandbox"

user.pub_key = nil
user.save
user.reload
user.pub_key # => nil

user.pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqvSdexJ11MpnL3IuFZo9d16VXpjSCqnsHusjmHLPslYCeOpAR5i166d
NpJKp0Mw94QeIoquoSd9eF5P0pYJvDts543FHdzIipQlkGijsuwoRna8u/2BoYljYoNc5bfxArYTviIoGuPh2z2GsPQY266fsGsq3ebuR6hpmJU1H6AfE4v2AIYnMh/
xA28qpZ1Yn6i4U4HSeaL6VpaVPlIyatVRD1QmQHHnENFnzR0uT3LMl9b8jLHmgHagRuppFycX4O5lh/d76+Dz9VlwMYKEaYRmUIpCtePff3CPZoBnwopz9PQ6mEsqx2
e3RfiRKUbSvtdBf+30fGmFXKNUY93 sandbox"
user.save
user.reload
```

```ruby
class User < ApplicationRecord
  attr_encryptor :pub_key,
                 secret: Rails.application.key_generator.generate_key('user/pub_key', ActiveSupport::MessageEncryptor.key_len),
                 cipher: 'aes-256-cbc',
                 digest: 'SHA256',
                 rotations: [
                   { secret: encryptor_secret, cipher: 'aes-256-gcm', digest: 'SHA1' }
                 ]
end

user = User.find(1)
user.pub_key # => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqvSdexJ11MpnL3IuFZo9d16VXpjSCqnsHusjmHLPslYCeOpAR5i166d
NpJKp0Mw94QeIoquoSd9eF5P0pYJvDts543FHdzIipQlkGijsuwoRna8u/2BoYljYoNc5bfxArYTviIoGuPh2z2GsPQY266fsGsq3ebuR6hpmJU1H6AfE4v2AIYnMh/
xA28qpZ1Yn6i4U4HSeaL6VpaVPlIyatVRD1QmQHHnENFnzR0uT3LMl9b8jLHmgHagRuppFycX4O5lh/d76+Dz9VlwMYKEaYRmUIpCtePff3CPZoBnwopz9PQ6mEsqx2
e3RfiRKUbSvtdBf+30fGmFXKNUY93 sandbox"
```

## TODO

- [ ] Complete test cases

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/songjiz/activerecord-encryptor.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
