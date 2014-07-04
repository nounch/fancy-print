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
  end

  require_relative 'controllers/init'
  require_relative 'routes/init'
end
