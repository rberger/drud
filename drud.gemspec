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
  spec.description  << 'NewMedia! Denver. It does not do much ... yet.'
  spec.homepage = 'https://github.com/newmediadenver/drud'
  spec.license = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n")
    .map { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'travis'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
