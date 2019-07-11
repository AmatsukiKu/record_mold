$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rails'
require 'active_record'
require 'record_mold'
require 'fake_app'
CreateAllTables.up unless ActiveRecord::Base.connection.table_exists? 'users'
