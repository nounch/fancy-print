module FancyPrint
  class App
    def plot_home
      haml :home, :layout => :application
    end

    def plot_plot
      if ['scatter', 'line', ''].include?(params[:type])
        response = {
          :data => JSON.parse(params[:data]),
          :description => params[:description] || '',
          :time => Time.now || '',
          :type =>
          ['scatter', ''].include?(params[:type])? 'line' : 'scatter',
        }
      elsif params[:type] == 'diff'
        diff = Diffy::Diff.new(params[:a], params[:b]).to_s(:html)
        ascii = Diffy::Diff.new(params[:a], params[:b])
        response = {
          :data => diff,
          :ascii => ascii,
          :description => params[:description] || '',
          :time => Time.now || '',
          :type => 'diff',
        }
      end

      $channel.push response.to_json
      # $channel.push 'Here is some data.'
      nil
    end
  end
end
