module FancyPrint
  class App
    def plot_home
      haml :home, :layout => :application
    end

    def plot_plot
      if ['scatter', 'line', ''].include?(params[:type])
        # Line + scatter plot
        response = {
          :data => JSON.parse(params[:data]),
          :description => params[:description] || '',
          :time => Time.now || '',
          :type =>
          ['scatter', ''].include?(params[:type])? 'line' : 'scatter',
        }
      elsif params[:type] == 'diff'
        # Diff
        diff = Diffy::Diff.new(params[:a], params[:b]).to_s(:html)
        ascii = Diffy::Diff.new(params[:a], params[:b])
        response = {
          :data => diff,
          :ascii => ascii,
          :description => params[:description] || '',
          :time => Time.now || '',
          :type => 'diff',
        }
      elsif params[:type] == 'text'
        # Text
        prefix = '<span class="text-highlighted">'
        suffix = '</span>'
        highlights = JSON.parse(params[:highlight]) || []
        regexps = JSON.parse(params[:regex]) || []
        text = params[:text]
        # Replace all strings
        highlights.each do |token|
          text.gsub!(token, prefix + "\\0" + suffix)
        end
        # Replace all RegExps
        regexps.each do |token|
          text.gsub!(Regexp.new(token), prefix + "\\0" + suffix)
        end
        response = {
          :data => text,
          :description => params[:description] || '',
          :time => Time.now || '',
          :type => 'text',
        }
      elsif params[:type] = 'markup'
        markup = params[:data]
        lang = params[:lang] || 'md'
        rendered = GitHub::Markup.render('file.' + lang, markup)
        response = {
          :data => rendered,
          :markup => markup,
          :description => params[:description] || '',
          :time => Time.now || '',
          :type => 'markup',
        }
      end

      $channel.push response.to_json
      nil
    end
  end
end
