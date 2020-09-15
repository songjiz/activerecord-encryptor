require "test_helper"

class ActiveRecord::EncryptorTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ActiveRecord::Encryptor::VERSION
  end
end
