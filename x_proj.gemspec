# -*- encoding: utf-8 -*-
require File.expand_path('../lib/x_proj/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Carol Nichols"]
  gem.email         = ["carol.nichols@gmail.com"]
  gem.description   = %q{Finds likely UI browser cross-compatibility issues.}
  gem.summary       = %q{Runs a command in multiple browsers using selenium then compares the screenshots and presents those likely to have cross-browser incompatibilities.}
  gem.homepage      = "http://carol-nichols.com"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "x_proj"
  gem.require_paths = ["lib"]
  gem.version       = XProj::VERSION

  gem.add_runtime_dependency "capybara", "~> 1.1.2"
  gem.add_development_dependency "sinatra", "~> 1.3.1"
end
