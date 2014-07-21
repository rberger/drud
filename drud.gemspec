# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drud/version'

Gem::Specification.new do |spec|
  spec.name          = 'drud'
  spec.version       = Drud::VERSION
  spec.authors       = ['Kevin Bridges']
  spec.email         = ['kevin@cyberswat.com']
  spec.summary       = 'Generates readmes for Newmedia Denver\'s Chef cookbooks.'
  spec.description   = 'This may be a bit domain specific. We use it to generate readmes for cookbooks.'
  spec.homepage      = 'https://newmediadenver.com/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'chef', '~>11.12.8'
  spec.add_runtime_dependency 'octokit', '~>3.0'
  spec.add_runtime_dependency 'rake', '~>10.3.2'
  spec.add_runtime_dependency 'foodcritic', '~>4.0'
  spec.add_runtime_dependency 'rubocop', '~>0.24.1'
  spec.add_runtime_dependency 'test-kitchen', '~>1.2.1'
  spec.add_runtime_dependency 'kitchen-vagrant', '~>0.15.0'
  spec.add_runtime_dependency 'vagrant-wrapper', '~>1.2.1.1'
  spec.add_runtime_dependency 'berkshelf', '~>3.1.4'
  spec.add_runtime_dependency 'rspec', '~> 3.0.0'
  spec.add_runtime_dependency 'bundler', '~> 1.6.4'
end
