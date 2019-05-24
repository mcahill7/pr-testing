require 'sinatra/base'
require 'json'

# Stelligent DemoApp
class DemoApp < Sinatra::Application
  get '/' do
    content_type :json
    {
      message: message
    }.to_json
  end

  def message
    'Hello World'
  end
end
