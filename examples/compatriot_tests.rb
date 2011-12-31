require 'compatriot'
require_relative "../spec/sample_app/sample_app"

Compatriot.app = SampleApp

Compatriot.run(%w[
  /
  /chrome-css-bug
])