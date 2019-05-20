require 'byebug'
require 'yaml'

class Generator < Thor::Group
  include Thor::Actions

  # Define arguments and options
  class_option :force, type: :boolean

  def self.source_root
    File.dirname(__FILE__)
  end

  def create_index_views

    routes.each do |route|
      @name = route
      destination = if route == '/'
                      '../../app/views/index.html.erb'
                    else
                      "../../app/views#{@name}/index.html.erb"
                    end

      generate_file('../templates/index_template.html.erb', destination)
    end
  end

  def create_controllers
    controllers.each do |controller|
      @controller_name = controller.split('#').first
      @method = controller.split('#').last
      destination = "../../app/controllers/#{@controller_name}.rb"

      generate_file('../templates/controller_template.erb', destination)
    end
  end

  private

  def routes
    hash = YAML.load(File.read("../../routes.yml"))
    hash.keys.reject { |path| path.nil? || path.empty? }
  end

  def controllers
    hash = YAML.load(File.read("../../routes.yml"))
    hash.values.reject { |path| path.nil? || path.empty? }
  end

  def force_create?(filename)
    File.exist?(filename) && options[:force]
  end

  def generate_file(source, destination)
    FileUtils.rm(destination) if force_create?(destination)

    if File.exist?(destination)
      puts "Skipping #{destination} because it already exists"
    else
      puts "Generating #{destination}"
      template(source, destination)
    end
  end
end