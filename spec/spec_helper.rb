# encoding: utf-8
require 'bundler/setup'
require 'coveralls'
require 'drud'
Coveralls.wear!
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
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end
