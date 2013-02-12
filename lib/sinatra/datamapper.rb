require 'sinatra/datamapper/version'
require 'dm-core'

module Sinatra
  #
  # Sinatra::DataMapper
  # ===================
  # Adds some syntactic sugar for setting up DataMapper with Sinatra.
  #
  # Example
  # =======
  #
  #   #!/usr/bin/env ruby
  #
  #   require 'sinatra'
  #   require 'data_mapper'
  #   require 'sinatra/datamapper'
  #
  #   class Post
  #     incude DataMapper::Resource
  #
  #     property :id,      Serial
  #     property :title,   String
  #     property :content, Text
  #   end
  #
  #   configure do
  #     set :datamapper_repositories, { default: 'sqlite3://#{Dir.pwd}/database.db' }
  #     set :datamapper_log_level, :debug
  #   end
  #
  #   get '/' do
  #     @posts = Post.all
  #     haml :posts
  #   end
  #
  module DataMapper
    def self.registered(app)
      # Setup the DataMapper logger information. TODO: Integrate with Sinatra/Rack CommonLogger if possible.
      app.set :datamapper_log_prefix, proc { "[DataMapper #{environment}] " }
      app.set :datamapper_log_path,   $stderr
      app.set :datamapper_log_level,  :info

      # Create the logger instance itself.
      ::DataMapper::Logger.new(
        settings.datamapper_log_path,
        settings.datamapper_log_level,
        settings.datamapper_log_prefix
      )

      # Load all configured repositories, defaulting to an in-memory sqlite3 database.
      app.set :datamapper_repositories, { :default => 'sqlite::memory:' }

      # Setup each repository, applying any specified naming conventions.
      settings.datamapper_repositories.each do |name, uri_or_options|
        if uri_or_options.is_a?(Hash)
          resource_scheme = uri_or_options.delete(:resource_naming_convention)
          field_scheme    = uri_or_options.delete(:field_naming_convention)
        end

        # Register the repository with DataMapper.
        ::DataMapper.setup(name, uri_or_options).tap do |adapter|
           # Apply resource/field naming conventions if they were defined in the options.
           adapter.resource_naming_convention = resource_scheme if resource_scheme
           adapter.field_naming_convention    = field_scheme if field_scheme
        end
      end

      # If available, load all models within the 'models' folder in the application root.
      app.set :datamapper_models, proc { root && ::File.join(root, 'models') }

      # If we have any models available, load them.
      if settings.datamapper_models
        import = ::Kernel.method(:require)
        pattern = settings.datamapper_models + '/**/*.rb'
        ::Dir[pattern].each(&import)
      end

      # Call DataMapper#finalize to initialize all DataMapper internals.
      ::DataMapper.finalize
    end
  end

  register(::Sinatra::DataMapper)
end
