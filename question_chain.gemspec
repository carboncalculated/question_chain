# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "question_chain/version"

Gem::Specification.new do |s|
  s.name        = "question_chain"
  s.version     = QuestionChain::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Richard Hooker"]
  s.email       = ["richard.hooker@carboncalculated.com"]
  s.homepage    = ""
  s.summary     = %q{Rails3 Gem to Generate Carbon Calculated Applications}
  s.description = %q{Rails3 Gem to Generate Carbon Calculated Applications}

  s.rubyforge_project = "question_chain"
  
  s.add_dependency 'mustache',         '>= 0.98.0'
  s.add_dependency 'mongo_mapper',     '~> 0.9.0'
  s.add_dependency 'mustache',         '>= 0.98.0'
  s.add_dependency 'hashie',           ">= 0.2.1"
  s.add_dependency 'crack',            ">= 0.1.8"
  s.add_dependency 'calculated',       ">= 0.1.5"
  s.add_dependency 'inherited_resources', "~> 1.2.0"
  s.add_dependency 'hunt',              "~> 0.3.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features,test_app}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
