class Router

  attr_reader :request, :path

  def initialize(request)
    @request = request
    @path = request.path
  end

  def route_request
    if root?
      success(root_template)
    elsif template?
      success
    else
      not_found
    end
  rescue StandardError => e
    error(e.message)
  end

  private

  def not_found(message = 'Not Found')
    [404, { 'Content-Type' => 'text/plain' }, [message]]
  end

  def success(content = view)
    [200, { 'Content-Type' => 'text/html' }, [content]]
  end

  def error(message = 'Server Error')
    [500, { 'Content-Type' => 'text/html' }, ["500 server error #{message}"]]
  end

  def view
    ERB.new(template).result
  end

  def template
    File.open("./app/views/#{path}/index.html.erb", 'r').read
  end

  def template?
    return false unless path
    File.exist?("./app/views/#{path}/index.html.erb")
  end

  def root?
    path == '/'
  end

  def root_template
    File.open('./app/views/index.html.erb', 'r').read
  end
end