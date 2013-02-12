# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra/datamapper/version'

Gem::Specification.new do |gem|
  gem.name          = "sinatra-datamapper"
  gem.version       = Sinatra::DataMapper::VERSION

  gem.authors       = ["Joshua M. Keyes"]
  gem.email         = ["joshua.michael.keyes@gmail.com"]

  gem.homepage      = "https://github.com/jmkeyes/sinatra-datamapper"
  gem.description   = %q{Easily integrate DataMapper with Sinatra}
  gem.summary       = %q{Sinata/DataMapper Extension}

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'datamapper', '~> 1.2.0'
end
