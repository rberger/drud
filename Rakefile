# encoding: utf-8
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

task default: :test
task test: [:rubocop, :spec]

desc 'Run RSpec tests'
RSpec::Core::RakeTask.new(:spec)

desc 'Run RuboCop style and lint checks'
Rubocop::RakeTask.new(:rubocop)
