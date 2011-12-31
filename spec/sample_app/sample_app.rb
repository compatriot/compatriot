require 'sinatra/base'
require 'rack'
require 'yaml'

class SampleApp < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :static, true

  get '/' do
    "<h1>Hello world!</h1><div><a href='chrome-css-bug'>Try another page</a></div>"
  end

  get "/chrome-css-bug" do
    "<table><tr style='background: url(/images/smileyface.jpg) no-repeat;'><td style='padding:30px;'>One</td><td style='padding:30px;'>Two</td></tr></table>"
  end

end

if __FILE__ == $0
  Rack::Handler::WEBrick.run SampleApp, :Port => 8070
end
