# encoding: utf-8
require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rdoc/task'

RDoc::Task.new do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('lib/*.rb', 'lib/drud/*.rb')
end

desc 'Run rspec tests'
RSpec::Core::RakeTask.new(:spec)

desc 'Run RuboCop style and lint checks'
RuboCop::RakeTask.new(:rubocop)

task :default => :rubocop

