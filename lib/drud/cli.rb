# encoding: utf-8
require 'drud'
require 'thor'

module Drud
  # The CLI module serves as the command line client wrapper for Drud.
  class CLI < Thor
    # The current drud version.
    VERSION = Drud::VERSION

    desc 'version', 'The current version of this software.'
    # Sends the current {Drud::VERSION drud version} to stdout.
    def version
      say(Drud::VERSION, :green)
    end
    # Provides error trapping for the command line client.
    def self.rescue
      shell = Thor::Base.shell.new
      yield
      rescue Thor::Error => e
        shell.say(e.message, :red)
        exit 1
    end
  end
end
