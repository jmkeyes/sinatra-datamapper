# Sinatra::DataMapper

Integrates DataMapper as a Sinatra extension; provides a some
syntactic sugar around setting up repositories, models, and
logging for DataMapper.

## Installation

Add this line to your application's Gemfile:

    gem 'sinatra-datamapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sinatra-datamapper

## Settings

### Logging

 + `:datamapper_log_prefix` sets the prefix of any lines logged.
 + `:datamapper_log_level` sets the logging level of DataMapper.
 + `:datamapper_log_path` sets where log lines should be sent to.

### Repositories

To configure repositories, set `:datamapper_repositories` to a
hash of which the key should be the repository name and the value
can be either a hash of a URI-like string. The extension passes
these to `DataMapper#setup`. If unset, defaults to an in-memory
SQLite3 database bound to the `:default` repository context.

### Models

By default, the extension will automatically load any Ruby source
files in the `models` folder of the application root. Set the
`:datamapper_models` setting to a path containing your models, or
to `false` to disable automatic loading.

## Example

In `models/post.rb`:

    class Post
      incude DataMapper::Resource
      property :id,      Serial
      property :title,   String
      property :content, Text
    end

In `application.rb`:

    #!/usr/bin/env ruby
 
    require 'sinatra'
    require 'data_mapper'
    require 'sinatra/datamapper'

    configure do
      set :datamapper_repositories, { default: 'sqlite3://#{Dir.pwd}/database.db' }
      set :datamapper_log_level, :debug
    end
 
    get '/' do
      @posts = Post.all
      haml :posts
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
