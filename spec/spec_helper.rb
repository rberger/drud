# encoding: utf-8
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage(80.00)
end

require 'bundler/setup'
require 'drud'
Bundler.setup
$0 = 'drud'
ARGV.clear

RSpec.configure do |config|
  # Use color output for RSpec
  config.color_enabled = true

  # Use documentation output formatter
  config.formatter = :documentation
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new" # rubocop:disable Eval
      yield
      result = eval("$#{stream}").string # rubocop:disable Eval
    ensure
      eval("$#{stream} = #{stream.upcase}") # rubocop:disable Eval
    end

    result
  end
end
