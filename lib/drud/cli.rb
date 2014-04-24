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
  end
end
