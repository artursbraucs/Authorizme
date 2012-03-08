# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "authorizme/version"

Gem::Specification.new do |s|
  s.name        = "authorizme"
  s.version     = Authorizme::VERSION
  s.authors     = ["Arturs Braucs", "Creative Mobile"]
  s.email       = ["arturs@creo.mobi"]
  s.homepage    = "https://github.com/CreativeMobile/Authorizme"
  s.summary     = %q{Simple authorization gem for basic and Oauth: facebook.com, twitter.com and draugiem.lv}
  s.description = %q{Authorization that includes basic authorization and 3 social authorization with Latvia social network draugiem.lv, facebook.com and twitter.com.}

  s.rubyforge_project = "authorizme"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'webrat'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  
  s.add_dependency "activesupport", "~> 3.2.1"
  s.add_dependency "rails", "~> 3.2.1"
  s.add_dependency "bcrypt-ruby"
  s.add_dependency "json"
  s.add_dependency "fb_graph"
  s.add_dependency "twitter_oauth"
  s.add_dependency "twitter"
end