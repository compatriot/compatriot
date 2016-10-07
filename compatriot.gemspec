# -*- encoding: utf-8 -*-
require File.expand_path('../lib/compatriot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Carol (Nichols || Goulding)", "Jeff Koenig"]
  gem.email         = ["carol.nichols@gmail.com", "jkoenig311@gmail.com"]
  gem.description   = 'Compare screenshots in your tests!'
  gem.summary       = %q{
    Add assertions that screenshots taken during your tests do not differ from a base image. Test that the page looks the same as the last test run or that the page looks the same in multiple browsers!
  }

  gem.homepage      = "https://github.com/carols10cents/compatriot"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "compatriot"
  gem.require_paths = ["lib"]
  gem.version       = Compatriot::VERSION
  gem.licenses      = "MIT"

  gem.add_development_dependency 'minitest', '~> 5.8', '>= 5.8.2'
  gem.add_development_dependency 'minitest-reporters', '~> 1.1', '>= 1.1.8'
  gem.add_development_dependency 'mocha', '~> 1.1', '>= 1.1.0'
  gem.add_development_dependency 'pry'

  gem.add_runtime_dependency 'capybara', '~> 2.5', '>= 2.5.0'
  gem.add_runtime_dependency 'selenium-webdriver', '~> 2.48', '>= 2.48.1'
  gem.add_runtime_dependency 'rake', '~> 10.4', '>= 10.4.2'
  gem.add_runtime_dependency 'chunky_png', '~> 1.3', '>= 1.3.5'
  gem.add_runtime_dependency 'oily_png', '~> 1.2.0'
  gem.add_runtime_dependency 'haml', '~> 4.0.7'
end
