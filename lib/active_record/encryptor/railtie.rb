module ActiveRecord
  module Encryptor
    class Railtie < Rails::Railtie

      initializer "active_record.encryptor" do
        ActiveSupport.on_load(:active_record) do
          include ActiveRecord::Encryptor
        end
      end

      initializer "active_record.register_encryption_type" do
        ActiveSupport.on_load(:active_record) do
          require "active_record/type/encryption"

          ActiveRecord::Type.register(:encryption, ActiveRecord::Type::Encryption, override: false)
        end
      end

      initializer "active_record.set_encryptor_secret" do |app|
        ActiveSupport.on_load(:after_initialize) do
          ActiveRecord::Base.encryptor_secret = app.config.active_record.encryptor_secret
          ActiveRecord::Base.encryptor_secret ||= -> { Rails.application.key_generator.generate_key("active_record/encryptor", ActiveSupport::MessageEncryptor.key_len) }
        end
      end
    end
  end
end
