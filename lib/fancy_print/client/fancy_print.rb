require 'net/http'
require 'json'
require 'base64'
require 'yaml'


###########################################################################
# Interface:
###########################################################################
#
# fp array
#   fp_plot array
# fp_diff string1, string2
# fp_text string
# fp_markup string
# fp_html string
# fp_svg string
# fp_image image
# fp_table data
#   fp_table data, :head
# fp_haml string
#
# Important: Any API changes to `FancyPrint::Client' have to be updated on
# `Object' manually. This allows the `FancyPrint::Client' library to differ
# from the top-level include. This is more flexible and it ensures that the
# top-level namespace does not get polluted. Top-level includes
# (methods/variables/...) should always have a unique name that is unlikely
# to interfere with pre-existing objects and objects from other libraries
# (e.g. `fp_plot'). Using the `fp_' prefix is preferred.


class InvalidFancyPrintData < StandardError
  attr_reader :object

  def initialize(message, object)
    super(message)
    @object = object
  end
end


module FancyPrint
  class Client
    public

    config = YAML.load_file(File.expand_path('../../../../bin/config.yaml',
                                             __FILE__))
    @@post_url = 'http://' + config[:host] + ':' + config[:port].to_s +
      '/plot'
    @@description_identifier = :msg

    def self.fp_plot(data, **options)
      description = options[@@description_identifier] || ''
      if options[:scatter]
        type = (options[:scatter] == false ? 'line' : 'scatter')
      else
        type = 'line'
      end
      Net::HTTP.post_form(URI.parse(@@post_url),
                          {
                            'data' =>
                            self.restructure_plot_data(data).to_json,
                            'description' => description.to_s,
                            'type' => type,
                          })
      nil
    end

    def self.fp(data, **options)
      self.fp_plot(data, options || {})
    end

    def self.fp_diff(a, b, **options)
      description = options[@@description_identifier] || ''
      Net::HTTP.post_form(URI.parse(@@post_url),
                          {
                            'a' => a.to_s,
                            'b' => b.to_s,
                            'description' => description.to_s,
                            'type' => 'diff',
                          })
      nil
    end

    def self.fp_text(text, **options)
      description = options[@@description_identifier] || ''
      highlight = options[:highlight] || []
      regex = options[:regex] || []
      if highlight.class != Array
        raise InvalidFancyPrintData.new('Only a list of strings allowed',
                                        highlight)
      end
      if regex.class != Array
        raise InvalidFancyPrintData.new('Not an array', regex)
      end
      Net::HTTP.post_form(URI.parse(@@post_url),
                          {
                            'highlight' => highlight.to_json,
                            'regex' => regex.to_json,
                            'text' => text.to_s,
                            'description' => description.to_s,
                            'type' => 'text',
                          })
      nil
    end

    def self.fp_markup(markup, **options)
      description = options[@@description_identifier] || ''
      lang = options[:lang] || 'md'
      Net::HTTP.post_form(URI.parse(@@post_url),
                          {
                            'data' => markup.to_s,
                            'lang' => lang.to_s,
                            'description' => description.to_s,
                            'type' => 'markup',
                          })
      nil
    end

    def self.fp_html(html, **options)
      description = options[@@description_identifier] || ''
      Net::HTTP.post_form(URI.parse(@@post_url),
                          {
                            'data' => html.to_s,
                            'description' => description.to_s,
                            'type' => 'html',
                          })
      nil
    end

    def self.fp_svg(svg, **options)
      description = options[@@description_identifier] || ''
      Net::HTTP.post_form(URI.parse(@@post_url),
                          {
                            'data' => svg.to_s,
                            'description' => description.to_s,
                            'type' => 'svg',
                          })
    end

    def self.fp_image(image, **options)
      image = Base64.encode64(image)
      description = options[@@description_identifier] || ''
      type = options[:type].downcase || 'png'
      Net::HTTP.post_form(URI.parse(@@post_url),
                          {
                            'data' => image,
                            'image_type' => type.to_s,
                            'description' => description.to_s,
                            'type' => 'image',
                          })
      nil
    end

    def self.fp_table(data, **options)
      table = data
      description = options[@@description_identifier] || ''
      if options[:head]
        head = options[:head] == true ? 'true' : 'false'
      else
        head = 'false'
      end
      if data.class != Array
        raise InvalidFancyPrintData.new('Not an array', data)
      end
      Net::HTTP.post_form(URI.parse(@@post_url),
                          {
                            'data' => table.to_json,
                            'head' => head.to_s,
                            'description' => description.to_s,
                            'type' => 'table',
                          })
      nil
    end

    def self.fp_haml(haml, **options)
      description = options[@@description_identifier] || ''
      Net::HTTP.post_form(URI.parse(@@post_url),
                          {
                            'data' => haml.to_s,
                            'description' => description.to_s,
                            'type' => 'haml',
                          })
      nil
    end

    private

    def self.restructure_plot_data(data)
      if data[0] && data[0].class != Array
        new_data = [[]]
        data.each_with_index do |dat, i|
          new_data[0] << [i, dat]
        end
      else
        new_data = data
      end
      new_data
    end
  end
end


# Attach methods to `Object' so they are available in the top level
# namespace.
class Object
  def fp_plot(data, **options)
    FancyPrint::Client.fp_plot(data, options || {})
  end

  def fp(data, **options)
    FancyPrint::Client.fp(data, options || {})
  end

  def fp_diff(a, b, **options)
    FancyPrint::Client.fp_diff(a, b, options || {})
  end

  def fp_text(text, **options)
    FancyPrint::Client.fp_text(text, options || {})
  end

  def fp_markup(markup, **options)
    FancyPrint::Client.fp_markup(markup, options || {})
  end

  def fp_html(html, **options)
    FancyPrint::Client.fp_html(html, options || {})
  end

  def fp_svg(svg, **options)
    FancyPrint::Client.fp_svg(svg, options || {})
  end

  def fp_image(image, **options)
    FancyPrint::Client.fp_image(image, options || {})
  end

  def fp_table(data, **options)
    FancyPrint::Client.fp_table(data, options || {})
  end

  def fp_haml(haml, **options)
    FancyPrint::Client.fp_haml(haml, options || {})
  end
end
