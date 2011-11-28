require 'sinatra/base'
require 'rack'
require 'yaml'

class TestApp < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :static, true

  get '/' do
    "<h1>Hello world!</h1"
  end

  get "/chrome-css-bug" do
    "<table><tr style='background: url(/images/smileyface.jpg) no-repeat;'><td style='padding:30px;'>One</td><td style='padding:30px;'>Two</td></tr></table>"
  end

end

if __FILE__ == $0
  Rack::Handler::WEBrick.run TestApp, :Port => 8070
end
