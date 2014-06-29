module FancyPrint
  class App
    def plot_home
      haml :home, :layout => :application
    end

    def generate_html_table(data, head)
      head = head || false
      max_cells = data.collect() { |row| row.length }.max
      html = '<table class="table table-hover table-responsive \
table-bordered table-condensed">'
      data.each_with_index do |row, idx|
        html << '<tr>'
        html << '<thead>' if (idx == 0 && head)
        max_cells.times do |i|
          html << (idx == 0 && head ? '<th>' : '<td>') +
            (CGI.escapeHTML(row[i].to_s) || '&nbsp;') +
            (idx == 0 && head ? '</th>' : '</td>')
        end
        html << '</thead><tbody>' if (idx == 0 && head)
        html << '</tr>'
      end
      html << '</tbody>' if head
      html << '</table>'
    end

    def plot_plot
      if ['scatter', 'line', ''].include?(params[:type])
        # Line + scatter plot
        response = {
          :data => JSON.parse(params[:data]),
          :description => params[:description] || '',
          :time => Time.now || '',
          :type =>
          ['scatter', ''].include?(params[:type]) ? 'scatter' : 'line',
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
      elsif params[:type] == 'markup'
        # Markup
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
      elsif params[:type] == 'html'
        # HTML
        response = {
          :data => params[:data],
          :description => params[:description] || '',
          :time => Time.now || '',
          :type => 'html',
        }
      elsif params[:type] == 'svg'
        # SVG
        response = {
          :data => params[:data],
          :description => params[:description] || '',
          :time => Time.now || '',
          :type => 'svg',
        }
      elsif params[:type] == 'image'
        # Image
        image_type = params[:img_type] || ''
        image_type += 'image/' if image_type != ''
        encoded = ';base64,' + params[:data]
        response = {
          :data => encoded.to_s,
          :description => params[:description] || '',
          :time => Time.now || '',
          :type => 'image',
        }
      elsif params[:type] == 'table'
        # Table
        if params[:head]
          head = (params[:head] == 'false' ? false : true)
        else
          head = false
        end
        table = generate_html_table(JSON.parse(params[:data]), head)
        response = {
          :data => table,
          :description => params[:description] || '',
          :time => Time.now || '',
          :type => 'table',
        }
      elsif params[:type] == 'haml'
        # Table
        html = Haml::Engine.new(params[:data]).render
        response = {
          :data => html,
          :description => params[:description] || '',
          :time => Time.now || '',
          :type => 'html',
        }
      end

      $channel.push response.to_json
      nil
    end
  end
end
