# frozen_string_literal: true
require "simplecov"
require 'simplecov-formatter-badge'

SimpleCov.start do
  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::BadgeFormatter
  ])
end

require "pg"
require "active_record"

require "seq_scanner"
require_relative "schema_builder"


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.before(:suite) do
    SchemaBuilder.build
  end

  config.around(:each) do |example|
    SchemaBuilder.truncate
    example.run
  end

  config.example_status_persistence_file_path = ".rspec_status"

  config.expose_dsl_globally = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
