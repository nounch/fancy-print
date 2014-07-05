module FancyPrint
  class App
    def info_client_info
      file = File.expand_path('../../../..', File.dirname(__FILE__)) +
        '/doc/client/client.md'
      markup = File.read(file)
      rendered = GitHub::Markup.render('file.md', markup)
      rendered.to_json
    end

    def info_api_info
      file = File.expand_path('../../../..', File.dirname(__FILE__)) +
        '/doc/api/api.md'
      markup = File.read(file)
      rendered = GitHub::Markup.render('file.md', markup)
      rendered.to_json
    end

    def info_cli_info
      file = File.expand_path('../../../..', File.dirname(__FILE__)) +
        '/doc/cli/cli.md'
      markup = File.read(file)
      rendered = GitHub::Markup.render('file.md', markup)
      rendered.to_json
    end
  end
end
