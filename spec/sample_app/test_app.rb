require 'sinatra/base'
require 'rack'
require 'yaml'

class TestApp < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :static, true

  get '/' do
    'Hello world! <a href="with_html">Relative</a>'
  end

end

if __FILE__ == $0
  Rack::Handler::WEBrick.run TestApp, :Port => 8070
end
