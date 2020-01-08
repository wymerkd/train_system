require 'rspec'
require 'pg'
require 'train'
require 'city'
require 'pry'
# require './config'

DB = PG.connect({:dbname => 'train_system'})
RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM trains *;")
    DB.exec("DELETE FROM cities *;")
  end
end
