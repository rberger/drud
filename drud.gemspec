# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = 'drud'
  spec.version = '0.0.1'
  spec.authors = ['Kevin Bridges']
  spec.email = ['kevin@cyberswat.com']
  spec.summary = 'A DevOps command line tool.'
  spec.description = 'Drud is a command line tool developed for use by '
  spec.description  << 'NewMedia! Denver.'
  spec.homepage = 'http://newmediadenver.com/'
  spec.license = 'MIT'

  spec.files = [
    'README.md',
    'Rakefile',
    'Gemfile',
    'lib/drud.rb',
    'lib/drud/cli.rb'
  ]

  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = [
    'spec/spec_helper.rb',
    'spec/version_spec.rb'
  ]
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'travis'
end
