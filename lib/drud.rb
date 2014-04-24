# encoding: utf-8
# Drud is a command line DevOps tool created for organizational insight and
# control.
module Drud
  # The current drud version.
  VERSION = '0.0.1'
  autoload :CLI, 'drud/cli'

  # Provides error trapping for the command line client.
  def self.rescue  # rubocop:disable MethodLength
    yield
  rescue Thor::AmbiguousTaskError => e
    puts e.message
    exit 1
  rescue Thor::Error => e
    # There must be a better way.
    if e.to_s.match(/"_v"/)
      puts self::VERSION
      exit 0
    else
      puts e.message
      exit 1
    end
  rescue Thor::UndefinedTaskError => e
    puts e.message
    exit 1
  rescue LoadError => e
    puts e.inspect
    exit 1
  rescue Interrupt => e
    puts e.inspect
    exit 1
  rescue SystemExit => e
    exit e.status
  end
end
