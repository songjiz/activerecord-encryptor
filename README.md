# ActiveRecord::Encryptor

Native encrypted attributes for ActiveRecord with ActiveSupport::MessageEncryptor.

**But do not support search by the unencrypted value.**

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
  attr_encryptor :pub_key
end
```

```ruby
user = User.new
user.pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqvSdexJ11MpnL3IuFZo9d16VXpjSCqnsHusjmHLPslYCeOpAR5i166d
NpJKp0Mw94QeIoquoSd9eF5P0pYJvDts543FHdzIipQlkGijsuwoRna8u/2BoYljYoNc5bfxArYTviIoGuPh2z2GsPQY266fsGsq3ebuR6hpmJU1H6AfE4v2AIYnMh/
xA28qpZ1Yn6i4U4HSeaL6VpaVPlIyatVRD1QmQHHnENFnzR0uT3LMl9b8jLHmgHagRuppFycX4O5lh/d76+Dz9VlwMYKEaYRmUIpCtePff3CPZoBnwopz9PQ6mEsqx2
e3RfiRKUbSvtdBf+30fGmFXKNUY93 sandbox"

user.encrypted_otp_secret # => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqvSdexJ11MpnL3IuFZo9d16VXpjSCqnsHusjmHLPslYCeOpAR5i166d
NpJKp0Mw94QeIoquoSd9eF5P0pYJvDts543FHdzIipQlkGijsuwoRna8u/2BoYljYoNc5bfxArYTviIoGuPh2z2GsPQY266fsGsq3ebuR6hpmJU1H6AfE4v2AIYnMh/
xA28qpZ1Yn6i4U4HSeaL6VpaVPlIyatVRD1QmQHHnENFnzR0uT3LMl9b8jLHmgHagRuppFycX4O5lh/d76+Dz9VlwMYKEaYRmUIpCtePff3CPZoBnwopz9PQ6mEsqx2
e3RfiRKUbSvtdBf+30fGmFXKNUY93 sandbox"

user.save
user.reload
user.pub_key # => "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqvSdexJ11MpnL3IuFZo9d16VXpjSCqnsHusjmHLPslYCeOpAR5i166d
NpJKp0Mw94QeIoquoSd9eF5P0pYJvDts543FHdzIipQlkGijsuwoRna8u/2BoYljYoNc5bfxArYTviIoGuPh2z2GsPQY266fsGsq3ebuR6hpmJU1H6AfE4v2AIYnMh/
xA28qpZ1Yn6i4U4HSeaL6VpaVPlIyatVRD1QmQHHnENFnzR0uT3LMl9b8jLHmgHagRuppFycX4O5lh/d76+Dz9VlwMYKEaYRmUIpCtePff3CPZoBnwopz9PQ6mEsqx2
e3RfiRKUbSvtdBf+30fGmFXKNUY93 sandbox"

user.encrypted_pub_key # => "fpOUXz4SO9ru/G0YsoFcQ/z0VtAx/790Unk+DZbX0Bfy9GTXG+iFULhlRqGCjyuC7sIAPhIx49gfRQrr5m8k4Goz48XrW4wb/mbBd/CZdc/tpbKQDLvH3XHK+J/mz9jIcprQ0WZ6ussO+92dmRa08pbRuKyAFS6LVJf/aiqJWHD3Yx2iwyddj54RvTCcZOc87p66SZ36gc9S/uKGg0wo3yJMK2lTu/SGX+n71nG3nrET8NZ9CeTGu+XnNYbl3XWhHicL2gh0vJ+m2DiY67kCPT/q6BroBDUh6I46CnwnaOMUTnPYsPZLBIrNKH6y3D+CovFtREj6/Vc5w5WmLJE3zRd/dUSSzlOUd5iQ2O866KlxluYHJiBSty6WCm+dcgPPQnKkan8rGB7l9ST6SsVyULOVboygjft1GiU3I02KQG4qFmoIEaXKGV25nTPkPZOUUzFQIX1+WVAf2cPkyFb8wPENHmFw56zfq36ToNfcFWZAaK+nf6EpLsFLdHlIS7iBzKO/Avtxg1IDYMURozSlRg==--5UTmhvIMMcRXlAHf--XJ6ufkh5DEKW6juBvs8JqQ=="

user.pub_key = nil
user.encrypted_pub_key # => nil
user.save
user.reload
user.pub_key # => nil
user.encrypted_pub_key # => nil

user.pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqvSdexJ11MpnL3IuFZo9d16VXpjSCqnsHusjmHLPslYCeOpAR5i166d
NpJKp0Mw94QeIoquoSd9eF5P0pYJvDts543FHdzIipQlkGijsuwoRna8u/2BoYljYoNc5bfxArYTviIoGuPh2z2GsPQY266fsGsq3ebuR6hpmJU1H6AfE4v2AIYnMh/
xA28qpZ1Yn6i4U4HSeaL6VpaVPlIyatVRD1QmQHHnENFnzR0uT3LMl9b8jLHmgHagRuppFycX4O5lh/d76+Dz9VlwMYKEaYRmUIpCtePff3CPZoBnwopz9PQ6mEsqx2
e3RfiRKUbSvtdBf+30fGmFXKNUY93 sandbox"
user.save
user.reload
user.encrypted_pub_key # => "HMuSYje0Q98G9f9dITpOi5VxCnrMN3JhJ7c5sVxZGDjb9zm7Ty3VM6WuWTlG0jxHVmsOE124i8/F9Zt5Ykim/CkTyJ0LRdceQpaRrLmc2yLFHbFU0fvYi0K0N11+nfvsEC6vZg1D3P2mOq4oV4SJBerdCpCOZo9D/bS5OF4cPQpHYgKE21QWPuidUXz+NDkx/zMz3b3mNSNeKxu30rKM6JThamEfGD7o7CL+wVigTrqnlLHtV6S47FWPIV0GWwpSfHHcSJ1tglVkqkDv9ef1B+HvzdycyEcoCEkNEriqRkJ5FpLiJUujuHFih90sIOj+WiJBBDM2efqJmLZNlzejkCmRSf0p0WF3lAXk0LRRmJW9rC3rXmnnKaVXvGkMLKbo1i0lP5UQ0GjYq39Kl2wQ2yYHgJUP1jPZYT5jclspTZbdU0+uLdH61v2H6O8jCnDb1TFX6soCh88QVXUgt9418OIKaCUUTC8PzP53XxUtECxHDFZlqDqEBvEmjlhpY14MJs3Gsa4ByZvMLcMnvi2mGg==--j80I+ukfXqZH/q94--WVtyHfRyE7V6AUsaOcOd7A=="
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
