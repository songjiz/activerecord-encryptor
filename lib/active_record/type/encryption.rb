module ActiveRecord
  module Type
    class Encryption < ActiveModel::Type::Value
      attr_reader :secret, :cipher, :digest, :rotations

      def initialize(secret:, cipher: nil, digest: nil, rotations: nil)
        @secret = secret
        @cipher = cipher
        @digest = digest
        @rotations = rotations
      end

      def type
        :encryption
      end

      def serialize(value)
        return if value.nil?

        encryptor.encrypt_and_sign(value)
      end

      private
        def cast_value(value)
          encryptor.decrypt_and_verify(value)
        rescue ActiveSupport::MessageEncryptor::InvalidMessage, ActiveSupport::MessageVerifier::InvalidSignature
          value
        end

        def encryptor
          @encryptor ||= build_encryptor
        end

        def resolve_secret(secret)
          secret.respond_to?(:call) ? secret.call : secret
        end

        def build_encryptor
          ActiveSupport::MessageEncryptor.new(resolve_secret(secret), cipher: cipher, digest: digest).tap do |encryptor|
            Array[rotations].flatten.reject(&:blank?).each do |options|
              options.assert_valid_keys(:secret, :cipher, :digest)

              old_secret = resolve_secret(options.delete(:secret))

              if old_secret.present?
                encryptor.rotate(old_secret, **options)
              else
                encryptor.rotate **options
              end
            end
          end
        end
    end
  end
end
