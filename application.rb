require 'erb'
require 'byebug'

application_files = File.expand_path('../app/**/*.rb', __FILE__)
Dir.glob(application_files).each { |file| require(file) }

class Application
  def call(env)
    @request = Rack::Request.new(env)
    Router.new(@request).route_request
  end
end
