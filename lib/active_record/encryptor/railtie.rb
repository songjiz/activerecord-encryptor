module ActiveRecord
  module Encryptor
    class Railtie < Rails::Railtie

      initializer "active_record.encryptor" do
        ActiveSupport.on_load(:active_record) do
          include ActiveRecord::Encryptor
        end
      end

      initializer "active_record.register_encrypted_type" do
        ActiveSupport.on_load(:active_record) do
          require "active_record/type/encrypted"

          ActiveRecord::Type.register(:encrypted, ActiveRecord::Type::Encrypted, override: false)
        end
      end

      initializer "active_record.set_encryptor_secret" do
        ActiveSupport.on_load(:active_record) do
          self.encryptor_secret ||= -> { Rails.application.key_generator.generate_key("active_record/encryptor", ActiveSupport::MessageEncryptor.key_len) }
        end
      end
    end
  end
end
