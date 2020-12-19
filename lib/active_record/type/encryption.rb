module ActiveRecord
  module Type
    class Encryption < ActiveModel::Type::Value

      attr_reader :secret, :cipher, :digest, :rotations
      delegate :cast, to: :subtype

      def initialize(subtype:, secret:, cipher: nil, digest: nil, rotations: nil, **options)
        @secret    = secret
        @cipher    = cipher
        @digest    = digest
        @rotations = rotations
        @subtype   = ActiveRecord::Type.lookup(subtype, **options)
        @encryptor = build_encryptor
      end

      def serialize(value)
        serialized = subtype.serialize(value)

        return if serialized.nil?

        encryptor.encrypt_and_sign(serialized)
      end

      def deserialize(value)
        return if value.nil?

        unencrypted = encryptor.decrypt_and_verify(value)
        subtype.deserialize(unencrypted)
      end

      def changed_in_place?(raw_old_value, value)
        old_value = deserialize(raw_old_value)
        subtype.changed_in_place?(old_value, value)
      end

      private

      attr_reader :subtype, :encryptor

      def resolve_secret(secret)
        secret.respond_to?(:call) ? secret.call : secret
      end

      def build_encryptor
        ActiveSupport::MessageEncryptor.new(resolve_secret(secret), cipher: cipher, digest: digest).tap do |encryptor|
          Array[rotations].flatten.reject(&:blank?).each do |options|
            options.assert_valid_keys(:secret, :cipher, :digest)

            old_secret = resolve_secret(options[:secret])

            if old_secret.present?
              encryptor.rotate old_secret, cipher: options[:cipher], digest: options[:digest]
            else
              encryptor.rotate cipher: options[:cipher], digest: options[:digest]
            end
          end
        end
      end
    end
  end
end
