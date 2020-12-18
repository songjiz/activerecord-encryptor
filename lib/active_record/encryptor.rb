require "active_record"
require "active_record/encryptor/version"

module ActiveRecord
  module Encryptor
    extend ActiveSupport::Concern

    included do
      mattr_accessor :encryptor_secret, instance_writer: false
    end

    module ClassMethods
      def encrypted_attribute(name, type, secret: nil, cipher: nil, digest: nil, rotations: nil, **options)
        secret ||= encryptor_secret

        attribute name.to_sym, :encryption, subtype: type, secret: secret, cipher: cipher, digest: digest, rotations: rotations, **options
      end
    end
  end
end
