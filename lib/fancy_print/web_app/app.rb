require 'sinatra/base'
require 'sinatra/asset_pipeline'
require 'sinatra/rroute'
require 'haml'
require 'json'
require 'diffy'
require 'github/markup'
require 'cgi'
require 'yaml'


module FancyPrint
  class App < Sinatra::Base
    register Sinatra::AssetPipeline
    register Sinatra::Rroute

    def initialize
      require_relative 'runner'
      Thread.new do
        FancyPrint::Runner.run()
      end
      super()
    end

    configure do
      config_file = File.expand_path('../../..', File.dirname(__FILE__)) +
        '/bin/config.yaml'
      config = YAML.load_file(config_file)
      set :websocket, {
        :host => config[:websocket_host],
        :port => config[:websocket_port],
      }
    end

  end

  require_relative 'controllers/init'
  require_relative 'routes/init'
end
