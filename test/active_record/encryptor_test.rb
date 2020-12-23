require "test_helper"

class ActiveRecord::EncryptorTest < Minitest::Test
  def setup
    @user = User.create
  end

  def test_defaults
    assert_equal User.attribute_types['pub_key'].secret, User.encryptor_secret
  end

  def test_encrypt_and_decrypt
    @user.pub_key = 'pub_key'
    @user.save
    @user.reload
    encrypted_pub_key = encrypted_attribute(@user, :pub_key)
    assert_equal @user.pub_key, 'pub_key'
    refute_equal @user.pub_key, encrypted_pub_key
    assert_operator @user.pub_key.length, :<, encrypted_pub_key.length
  end

  def test_nil
    @user.pub_key = nil
    @user.save
    @user.reload
    encrypted_pub_key = encrypted_attribute(@user, :pub_key)
    assert_nil @user.pub_key
    assert_nil encrypted_pub_key
  end

  def test_set_options
    User.class_eval do
      encrypted_attribute :pub_key, :text,
                     cipher: 'aes-256-cbc',
                     digest: 'SHA256',
                     rotations: [ { cipher: 'aes-256-gcm', digest: 'SHA1' } ]
    end

    assert_equal User.attribute_types['pub_key'].cipher, 'aes-256-cbc'
    assert_equal User.attribute_types['pub_key'].digest, 'SHA256'
    assert_equal User.attribute_types['pub_key'].rotations, [ { cipher: 'aes-256-gcm', digest: 'SHA1' } ]
  end

  def test_rotations
    User.class_eval do
      encrypted_attribute :pub_key, :text, secret: encryption_secrets[:old]
    end
    @user.pub_key = 'pub_key'
    @user.save
    assert_equal @user.pub_key, 'pub_key'
    refute_equal @user.pub_key, encrypted_attribute(@user, :pub_key)

    User.class_eval do
      encrypted_attribute :pub_key, :text, secret: encryption_secrets[:new]
    end
    @user = User.find(@user.id)
    # can't decrypt the pub_key then return the raw value
    assert_raises(ActiveSupport::MessageVerifier::InvalidSignature) do
      @user.pub_key
    end

    User.class_eval do
      encrypted_attribute :pub_key, :text, secret: encryption_secrets[:new], rotations: [ { secret: encryption_secrets[:old] }]
    end
    @user = User.find(@user.id)
    assert_equal @user.pub_key, 'pub_key'
  end
end
