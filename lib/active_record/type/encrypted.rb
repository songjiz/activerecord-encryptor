module ActiveRecord
  module Type
    class Encrypted < ActiveModel::Type::Value
      attr_reader :secret, :cipher, :digest, :rotations

      def initialize(secret:, cipher: nil, digest: nil, rotations: nil)
        @secret = secret
        @cipher = cipher
        @digest = digest
        @rotations = rotations
      end

      def type
        :encrypted
      end

      def deserialize(value)
        return nil if value.nil?

        encryptor.decrypt_and_verify value
      rescue ActiveSupport::MessageEncryptor::InvalidMessage
        value
      end

      def serialize(value)
        return nil if value.nil?

        encryptor.encrypt_and_sign value
      end

      private
        def encryptor
          @encryptor ||= build_encryptor
        end

        def resolve_secret(secret)
          secret.respond_to?(:call) ? secret.call : secret
        end

        def build_encryptor
          ActiveSupport::MessageEncryptor.new(resolve_secret(secret), cipher: cipher, digest: digest).tap do |encryptor|
            Array[rotations].flatten.reject(&:blank?).each do |rotator_options|
              rotator_options.assert_valid_keys(:secret, :cipher, :digest)

              old_secret = resolve_secret(rotator_options.delete(:secret))

              if old_secret.present?
                encryptor.rotate(old_secret, **rotator_options)
              else
                encryptor.rotate **rotator_options
              end
            end
          end
        end
    end
  end
end