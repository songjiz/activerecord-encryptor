require "active_record"
require "active_record/encryptor/version"

module ActiveRecord
  module Encryptor
    extend ActiveSupport::Concern

    included do
      mattr_accessor :encryptor_secret, instance_writer: false
    end

    module ClassMethods
      def attr_encryptor(*attributes)
        options = attributes.extract_options!
        options.assert_valid_keys(:secret, :cipher, :digest, :rotations)

        options[:secret] ||= encryptor_secret

        attributes.each do |name|
          attribute name.to_sym, :encryption, **options

          define_method :"encrypted_#{name}" do
            send :"#{name}_before_type_cast"
          end
        end
      end
    end
  end
end
