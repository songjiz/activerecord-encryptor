module ActiveRecord
  module Encryptor
    class Railtie < Rails::Railtie

      initializer "active_record.encrypted_attributes" do
        ActiveSupport.on_load(:active_record) do
          include ActiveRecord::EncryptedAttributes
        end
      end

      initializer "active_record.encryption_type" do
        ActiveSupport.on_load(:active_record) do
          require "active_record/type/encrypted"

          ActiveRecord::Type.register(:encrypted, ActiveRecord::Type::Encrypted, override: false)
        end
      end

      initializer "active_record.set_encryptor_secret" do
        ActiveSupport.on_load(:after_initialize) do
          ActiveRecord::Base.encryptor_secret = config.active_record.encryptor_secret || -> { Rails.application.key_generator.generate_key("active_record/encrypted_attributes") }
        end
      end
    end
  end
end
