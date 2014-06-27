module FancyPrint
  class App
    # Home
    gget '/' => :plot_home, :as => :home_path, :mask => '/'

    # Plotting
    ppost %r{/plot/?} => :plot_plot, :as => :plot_path, :mask => '/plot'
  end
end
