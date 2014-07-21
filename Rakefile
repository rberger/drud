# encoding: utf-8
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'nested']
end

desc 'Run RuboCop style and lint checks'
RuboCop::RakeTask.new(:rubocop)

task :default => :rubocop

