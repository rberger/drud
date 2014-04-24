# encoding: utf-8
# Drud is a command line DevOps tool created for organizational insight and
# control.
module Drud
  # The current drud version.
  VERSION = '0.0.1'
  autoload :CLI, 'drud/cli'

  # Provides error trapping for the command line client.
  def self.rescue
    shell = Thor::Base.shell.new
    yield
    rescue Thor::Error => e
      shell.say(e.message, :red)
  end
end
