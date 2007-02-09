# Load the environment
ENV['DB'] ||= 'in_memory'
require File.dirname(__FILE__) + '/app_root/config/environment.rb'

# Load the testing framework
require 'test/unit'
require 'active_record/fixtures'

# Load the plugin
$:.unshift(File.dirname(__FILE__) + '/../lib')
require File.dirname(__FILE__) + '/../init'

# Run the migrations
ActiveRecord::Migrator.migrate("#{APP_ROOT}/db/migrate")

# Load fixtures
Test::Unit::TestCase.fixture_path = "#{APP_ROOT}/test/fixtures/"
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

class Test::Unit::TestCase #:nodoc:
  def create_fixtures(*table_names)
    if block_given?
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names) { yield }
    else
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names)
    end
  end
  
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end