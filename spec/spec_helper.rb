# encoding: utf-8
require 'bundler/setup'
Bundler.setup

require 'drud'

RSpec.configure do |config|
  # Use color output for RSpec
  config.color_enabled = true

  # Use documentation output formatter
  config.formatter = :documentation
end
