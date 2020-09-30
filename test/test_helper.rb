$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'active_record'
require "active_record/encryptor"
require "active_record/type/encryption"
require "securerandom"
require "sqlite3"
require "minitest/autorun"

ActiveRecord::Base.send :include, ActiveRecord::Encryptor
ActiveRecord::Type.register(:encryption, ActiveRecord::Type::Encryption, override: false)

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table "users", force: :cascade do |t|
    t.text "pub_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.encryption_secrets
    @encryption_secrets ||= Hash.new { |h, k| h[k] = SecureRandom.random_bytes(32) }
  end
end

ApplicationRecord.encryptor_secret = ApplicationRecord.encryption_secrets[:default]

class User < ApplicationRecord
  attr_encryptor :pub_key
end

def encrypted_attribute(model, name)
  table = model.class.arel_table
  sm = Arel::SelectManager.new(model.class)
  sm.from(table)
  sm.project(name)
  sm.where(table[model.class.primary_key].eq(model.id))

  ActiveRecord::Base.connection.exec_query(sm.to_sql.squish).first[name.to_s]
end