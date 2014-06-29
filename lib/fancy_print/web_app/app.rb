require 'sinatra/base'
require 'sinatra/asset_pipeline'
require 'sinatra/rroute'
require 'haml'
require 'em-websocket'
require 'thin'
require 'json'
require 'diffy'
require 'github/markup'
require 'cgi'
require 'yaml'


$channel = EventMachine::Channel.new

EventMachine.run do

  EventMachine::WebSocket.start(:host => '127.0.0.1', :port =>
                                '3055') do |ws|
    ws.onopen do |handshake|
      $sid = $channel.subscribe { |msg| ws.send msg }
      # $channel.push "#{$sid} connected!"
      # ws.send 'Hello there: #{handshake.path}'
    end

    # ws.onmessage do |msg|
    #   puts '---------- Message'
    #   # $channel.push "<#{$sid}: #{msg}"
    #   $channel.push "onmessage"
    # end

    # ws.onclose do
    #   puts '---------- Close'
    #   $channel.unsubscribe($sid)
    # end
  end



  module FancyPrint
    class App < Sinatra::Base
      register Sinatra::AssetPipeline
      register Sinatra::Rroute
    end
  end


  require_relative 'controllers/init'
  require_relative 'routes/init'

  config =
    YAML.load_file(File.expand_path('../../../../bin/config.yaml',
                                    __FILE__))
  Thin::Server.start(FancyPrint::App, config['host'].to_s,
                     config['port'].to_i)
  Signal.trap('TERM') { exit 0  }
  Signal.trap('INT') { exit 0  }
  # Alternative (without the app):
  #
  # Thin::Server.run!
end
