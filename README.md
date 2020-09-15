# ActiveRecord::Encryptor

Encrypt and decrypt attributes of ActiveRecord with ActiveSupport::MessageEncryptor.

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
ActiveRecord::Schema.define(version: 2020_09_15_154433) do

  create_table "users", force: :cascade do |t|
    t.string "otp_secret"
    t.string "ssn"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
```

```ruby
class User < ApplicationRecord
  attr_encryptor :otp_secret, :ssn
end
```

```ruby
user = User.new
user.otp_secret = '123456'
user.encrypted_otp_secret # => "123456"
user.ssn = '1111111111'
user.encrypted_ssn # => "1111111111"
user.save
user.id # => 1
user.encrypted_otp_secret # => "z+IRtCMvMtr567eQ+0NfRg==--jPDcBZ7C46B5I83U--ZXz8LcM/g2ZTyyI2aBj1Qw=="
user.encrypted_ssn # => "colDFyYK8JtZ9s6gtskzdEhdUCA=--kSEtVv1sl2u9IAXx--djE1hGAgSSRQbXcUpOUN3g=="

user.otp_secret = nil
user.encrypted_otp_secret # => nil
user.save
user.encrypted_otp_secret # => nil
```

```ruby
class User < ApplicationRecord
  attr_encryptor :otp_secret

  attr_encryptor :ssn,
                 secret: Rails.application.key_generator.generate_key('user/ssn', ActiveSupport::MessageEncryptor.key_len),
                 cipher: 'aes-256-cbc',
                 digest: 'SHA256',
                 rotations: [
                   { secret: User.encryptor_secret, cipher: 'aes-256-gcm', digest: 'SHA1' }
                 ]
end

user = User.find(1)
user.ssn # => "1111111111"
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
