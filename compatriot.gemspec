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

  if RUBY_PLATFORM =~ /1\.8/
    gem.add_development_dependency 'minitest', '~> 2.6.2'
    gem.add_dependency 'backports', '~> 2.3.0'
  end

  gem.add_development_dependency 'sinatra', '~> 1.3.1'
  gem.add_dependency 'capybara', '~> 1.1.2'
  gem.add_dependency 'rake', '~> 0.9.2.2'
  gem.add_dependency 'chunky_png', '~> 1.2.5'
end
