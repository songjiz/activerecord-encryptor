require "active_record"
require "active_record/encryptor/version"

if defined?(Rails::Railtie)
  require "active_record/encryptor/railtie"
end

module ActiveRecord
  module Encryptor
    extend ActiveSupport::Concern

    included do
      mattr_accessor :encryptor_secret, instance_writer: false
    end

    module ClassMethods
      def attr_encryptor(*attributes)
        options = attributes.extract_options!
        options.assert_valid_keys(:secret, :salt, :cipher, :digest, :rotations)

        options[:secret] ||= encryptor_secret
        
        attributes.each do |name|
          attribute name.to_sym, :encrypted, **options
          
          define_method :"encrypted_#{name}" do
            send :"#{name}_before_type_cast"
          end
        end
      end
    end
  end
end