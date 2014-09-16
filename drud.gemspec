# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drud/version'

Gem::Specification.new do |spec|
  spec.name          = 'drud'
  spec.version       = Drud::VERSION
  spec.authors       = ['Kevin Bridges']
  spec.email         = ['kevin@cyberswat.com']
  spec.required_ruby_version = '>= 1.9.3'
  spec.summary       = 'Generates the README.md file for Chef cookbooks.'
  desc = 'Evaluates an opscode chef cookbook\'s metadata and github history to'
  desc << ' generate a README.md file. The README.rb is placed in the root '
  desc << 'level of the cookbook. This forces cookbook developers to properly '
  desc << 'use metadata to document their cookbooks efficiently.  Additionally'
  desc << ', it provides proper attribution for all committers in the project '
  desc << 'with links back to the contributors github profile. It is written '
  desc << 'to take advantage of cookbooks that properly utilize both Rake '
  desc << 'tasks and metadata.'

  spec.description   = desc
  spec.homepage      = 'https://github.com/newmediadenver/drud'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'chef', '>= 11.12.8'
  spec.add_runtime_dependency 'octokit', '~> 3.0'
  spec.add_runtime_dependency 'rake', '~> 10.3.2'

  spec.add_development_dependency 'rspec', '~> 3.0.0'
  spec.add_development_dependency 'rubocop', '~> 0.24.1'
end
