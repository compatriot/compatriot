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

  # To get the newest minitest features!
  gem.add_development_dependency 'minitest', '~> 2.8.1'
  gem.add_development_dependency 'sinatra',  '~> 1.3.1'
  gem.add_development_dependency 'mocha',    '~> 0.10.0'
  gem.add_development_dependency 'cucumber', '~> 1.1.4'
  gem.add_development_dependency 'aruba',    '~> 0.4.11'
  gem.add_development_dependency 'relish',   '~> 0.5.3'

  gem.add_dependency 'capybara',   '~> 1.1.2'
  gem.add_dependency 'rake',       '~> 0.9.2.2'
  gem.add_dependency 'chunky_png', '~> 1.2.5'
end
