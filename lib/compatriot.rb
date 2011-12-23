require "compatriot/version"
require "compatriot/runner"
require "compatriot/browser"
require "compatriot/results_presenter"
require "compatriot/image_differ/image_differ"

module Compatriot
  class << self
    attr_accessor :app

    def run(paths)
      Compatriot::Runner.start(app, paths)
    end
  end
end