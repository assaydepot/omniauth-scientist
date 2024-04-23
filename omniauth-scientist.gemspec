# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-scientist/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Petersen"]
  gem.email         = ["chris@scientist.com"]
  gem.description   = %q{Official OmniAuth strategy for Scientist.}
  gem.summary       = %q{Official OmniAuth strategy for Scientist.}
  gem.homepage      = "https://github.com/assaydepot/omniauth-scientist"
  gem.license       = "MIT"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-scientist"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Scientist::VERSION

  gem.add_dependency 'omniauth', '~> 2.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.8'
  gem.add_development_dependency 'rspec', '~> 3.5'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'webmock'
end
