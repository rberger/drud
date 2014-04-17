# encoding: utf-8
require 'bundler/setup'
require 'coveralls'
require 'drud'
Coveralls.wear!
Bundler.setup
RSpec.configure do |config|
  # Use color output for RSpec
  config.color_enabled = true

  # Use documentation output formatter
  config.formatter = :documentation
end
