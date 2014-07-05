module FancyPrint
  class App
    # Home
    gget '/' => :plot_home, :as => :home_path, :mask => '/'

    # Plotting
    ppost %r{/plot/?} => :plot_plot, :as => :plot_path, :mask => '/plot'

    # WebSocket
    gget %r{/websocket/info/?} => :plot_websocket_info, :as =>
      :websocket_info_path, :mask => '/websocket/info'
  end
end
