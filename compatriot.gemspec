# -*- encoding: utf-8 -*-
require File.expand_path('../lib/compatriot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Carol Nichols"]
  gem.email         = ["carol.nichols@gmail.com"]
  gem.description   = 'Finds likely UI browser cross-compatibility issues.'
  gem.summary       = %q{
    Runs a command in multiple browsers using selenium then compares the
    screenshots and presents those likely to have cross-browser incompatibilities.
  }

  gem.homepage      = "https://github.com/clnclarinet/compatriot"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "compatriot"
  gem.require_paths = ["lib"]
  gem.version       = Compatriot::VERSION
  gem.licenses      = "MIT"

  gem.add_development_dependency 'minitest', '~> 5.8', '>= 5.8.2'
  gem.add_development_dependency 'sinatra', '~> 1.4', '>= 1.4.6'
  gem.add_development_dependency 'mocha', '~> 1.1', '>= 1.1.0'
  gem.add_development_dependency 'pry'

  gem.add_runtime_dependency 'capybara', '~> 2.5', '>= 2.5.0'
  gem.add_runtime_dependency 'selenium-webdriver', '~> 2.48', '>= 2.48.1'
  gem.add_runtime_dependency 'rake', '~> 10.4', '>= 10.4.2'
  gem.add_runtime_dependency 'chunky_png', '~> 1.3', '>= 1.3.5'
  gem.add_runtime_dependency 'oily_png', '~> 1.2.0'
end
