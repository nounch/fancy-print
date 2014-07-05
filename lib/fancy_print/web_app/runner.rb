require 'em-websocket'
require 'thin'
require 'yaml'

require_relative 'app'


module FancyPrint
  class Runner
    def self.run
      $channel = EventMachine::Channel.new

      config_file = File.expand_path('../../..', File.dirname(__FILE__)) +
        '/bin/config.yaml'
      config = YAML.load_file(config_file)

      EventMachine.run do

        EventMachine::WebSocket.start(:host => (config[:websocket_host] ||
                                                'localhost'), :port =>
                                      (config[:websocket_port].to_s ||
                                       '5503')) do |ws|
          ws.onopen do |handshake|
            $sid = $channel.subscribe { |msg| ws.send msg }
          end
        end

        config =
          YAML.load_file(File.expand_path('../../../../bin/config.yaml',
                                          __FILE__))
        Thin::Server.start(FancyPrint::App, config[:host].to_s,
                           config[:port].to_i)
        Signal.trap('TERM') { exit 0 }
        Signal.trap('INT') { exit 0 }
      end
    end
  end
end
