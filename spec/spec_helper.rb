ENV['COINS_PAID_CURRENCY'] = 'EUR'

if ENV['CIRCLE_ARTIFACTS']
  require 'simplecov'
  SimpleCov.start
end

require 'active_record'
require 'active_record/railtie'
require 'rspec/rails'
require 'rspec/its'
require 'rqrcode'

require 'coins_paid_rails'

Dir['./spec/support/**/*.rb'].each { |f| require f }

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'spec/test.db')

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.before :suite do
    CreateTable.migrate(:up)
  end
end
