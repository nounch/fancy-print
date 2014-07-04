require 'em-websocket'
require 'thin'

require_relative 'app'


module FancyPrint
  class Runner
    def self.run
      $channel = EventMachine::Channel.new

      EventMachine.run do

        EventMachine::WebSocket.start(:host => '127.0.0.1', :port =>
                                      '5503') do |ws|
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
