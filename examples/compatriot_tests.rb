require 'compatriot'
require_relative "../spec/sample_app/test_app"

Compatriot.app = TestApp

Compatriot.run(%w[
  /
  /chrome-css-bug
])