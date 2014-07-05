module FancyPrint
  class App
    # Home
    gget '/' => :plot_home, :as => :home_path, :mask => '/'

    # Plotting
    ppost %r{/plot/?} => :plot_plot, :as => :plot_path, :mask => '/plot'

    # WebSocket
    gget %r{/websocket/info/?} => :plot_websocket_info, :as =>
      :websocket_info_path, :mask => '/websocket/info'

    # Info
    gget %r{/info/doc/client/?} => :info_client_info, :as =>
      :client_info_path, :mask => '/info/doc/client'
    gget %r{/info/doc/api/?} => :info_api_info, :as =>
      :client_api_path, :mask => '/info/doc/api'
    gget %r{/info/doc/cli/?} => :info_cli_info, :as =>
      :client_cli_path, :mask => '/info/doc/cli'
  end
end
