require 'docopt'
require 'json'
require 'yaml'

require_relative '../client/fancy_print'


module FancyPrint
  class CLI

    def self.run(command_name)
      command_name = command_name
      doc = <<-DOCOPT
FancyPrint prints things to your browser.

Usage:
  #{command_name} -h|--help
  #{command_name} server [--host=<hostname>] [-p=<port>|--port=<port>] [--websocket-port=<ws_port>] [--websocket-host=<ws_host>]
  #{command_name} plot [<data>|-f <file>] [--scatter] [--msg=<message>]
  #{command_name} diff [<string1> <string2>|--file1=<file1> --file2=<file2>] [--msg=<message>]
  #{command_name} text [<string>|-f <file>] [--highlight=<strings>|--regex=<regexps>] [--msg=<message>]
  #{command_name} markup [<string>|-f <file>] --lang=<extension> [--msg=<message>]
  #{command_name} html [<string>|-f <file>] [--msg=<message>]
  #{command_name} svg [<string>|-f <file>] [--msg=<message>]
  #{command_name} image <file> [--msg=<message>]
  #{command_name} table [<data>|-f <file>] [--head] [--msg=<message>]
  #{command_name} haml [<string>|-f <file>] [--msg=<message>]

Options:
  --h  --help              Show this help.
  --host=<hostname>        Host to use for the server.
  -p=<port> --port=<port>  Port to use for the server.
  --scatter                Use scatter plot (instead of line plot).
  --highlight=<strings>    A list of strings to hightlight.
  --regex=<regexps>        A list of regular expressions to hightlight.
  --lang=<extension>       Markup language type (file extension like `md' or `textile').
  --head                   Use the first subarray of the data array as table head.

DOCOPT

      options = []
      begin
        options = Docopt::docopt(doc, :help => true)
      rescue Docopt::Exit => e
        puts e.message
      end

      # Sanitize command line options by fixing escape sequences.
      #
      # @param [String] string A command line parameter string.
      #
      # @return [String] Escaped string.
      def unescape_string(string)
        YAML.load(%Q(---\n"#{string}"\n))
      end

      begin
        if !options.empty?
          if options['server']
            # Write the config file for the web app and the client etc. to
            # read from.
            config_file =
              File.expand_path('../../..', File.dirname(__FILE__)) +
              '/bin/config.yaml'
            config_file_written = false
            config = {
              :host => options['--host'] || 'localhost',
              :port =>
              (options['--port'].to_i if options['--port']) || 4321,
              :websocket_port =>
              (options['--websocket-port'].to_i if
               options['--websocket-port']) || 5503,
              :websocket_host =>
              (options['--websocket-host'] if
               options['--websocket-host']) || 'localhost',
            }
            File.delete(config_file) if File.exists?(config_file)
            File.open(config_file, 'w+') do |f|
              f.write(config.to_yaml)
              config_file_written = true
            end
            # Start the server.
            Dir.chdir(File.expand_path('../../web_app/', __FILE__)) do
              # `require_relative' is always relative to the file it is
              # included in; so it still needs the prefix
              # `../lib/fancy_print/T' here (despite being run in the
              # `Dir.chdir' block). `sinatra-asset-pipeline', however,
              # depends on the current working directory to be the one
              # where `app.rb' is located at. Hence the use of the
              # `Dir.chdir' block.
              if config_file_written
                # Alternative to starting the WebSocket server:
                #
                # require_relative '../web_app/runner'
                # Thread.new do
                #   FancyPrint::Runner.run()
                # end

                # Start the application server.
                require 'rack'
                require_relative '../web_app/app'
                options = {
                  :Host => config[:host],
                  :Port => config[:port],
                }
                Rack::Handler::Thin.run(FancyPrint::App,
                                        options) do |server|
                  [:INT, :TERM].each do |sig|
                    Signal.trap(sig) { server.stop }
                  end
                end
              end
            end
          elsif options['plot']
            data = JSON.parse(options['<data>'] ||
                              File.read(options['<file>']))
            fp_plot(data, :msg => options['--msg'] || '', :scatter =>
                    options['--scatter'])
          elsif options['diff']
            a = options['<string1>'] || File.read(options['--file1'])
            b = options['<string2>'] || File.read(options['--file2'])
            fp_diff(a, b, :msg => options['--msg'] || '')
          elsif options['text']
            fp_text(options['<string>'] || File.read(options['<file>']),
                    :msg => options['--msg'] || '')
          elsif options['markup']
            fp_markup(unescape_string(options['<string>']) ||
                      File.read(options['<file>']), :lang =>
                      options['lang'] || 'md', :msg => options['--msg'] ||
                      '')
          elsif options['html']
            fp_html(options['<string>'] || File.read(options['<file>']),
                    :msg => options['--msg'] || '')
          elsif options['svg']
            fp_svg(options['<string>'] || File.read(options['<file>']),
                   :msg => options['--msg'] || '')
          elsif options['image']
            image = options['<file>']
            fp_image(File.read(image), :type =>
                     File.extname(image).gsub(%r{\.}, ''), :msg =>
                     options['--msg'] || '')
          elsif options['table']
            data = JSON.parse(options['<data>'] ||
                              File.read(options['<file>']))
            fp_table(data, :head => options['--head'], :msg =>
                     options['--msg'] || '')
          elsif options['haml']
            if options['<string>']
              begin
                markup = unescape_string(options['<string>'])
              rescue
                markup = options['<string>']
              end
            else
              markup = File.read(options['<file>'])
            end
            fp_haml(markup, :msg => options['--msg'] || '')
          end
        end
      rescue Exception => exception
        puts <<-HINT
Seems like something is wrong. It could be one of those things:

  - There is no server running.
  - The data format is not correct.
  - The command line syntax is incorrect.
  - Any combination of the above.

Be sure to check out `#{command_name} --help'.
HINT
      end
    end

  end
end
