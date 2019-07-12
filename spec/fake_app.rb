# frozen_string_literal: true

case ENV['TEST_DATABASE_ADAPTER']
when 'postgresql'
  ActiveRecord::Base.establish_connection(adapter: 'postgresql', database: 'testdb', user: 'postgres', password: 'password', port: 5432, host: '127.0.0.1')
else
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
end

module RecordMoldTestApp
  Application = Class.new(Rails::Application) do
    config.eager_load = false
    config.active_support.deprecation = :log
  end.initialize!
end

# models
class User < ActiveRecord::Base
  enum register_method: {email: 1, twitter: 2, facebook: 3, google: 4}
end

# migrations
class CreateAllTables < ActiveRecord::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :name, limit: 30, null: false
      t.text :introduction
      t.integer :age, null: false
      t.integer :height
      t.boolean :left, null: false
      t.integer :register_method, null: false
      t.string :my_number, null: false
      t.index :my_number, unique: true
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
