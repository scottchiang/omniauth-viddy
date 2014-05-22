# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth/viddy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sean Stavropoulos"]
  gem.email         = ["sean@fullscreen.net"]
  gem.description   = %q{Viddy OAuth2 strategy}
  gem.summary       = %q{Viddy OAuth2 strategy}
  gem.homepage      = "https://github.com/Fullscreen/omniauth-viddy"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-viddy"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::Viddy::VERSION

  gem.add_runtime_dependency 'oauth2', '~> 0.4'

  gem.add_development_dependency 'rspec', '~> 2.6'
  gem.add_development_dependency 'rake'
end
