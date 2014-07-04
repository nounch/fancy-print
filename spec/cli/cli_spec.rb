require 'rspec'
require 'rspec/expectations'
require 'rack/test'
require 'json'

require_relative '../../lib/fancy_print/web_app/app'


describe 'CLI' do
  include Rack::Test::Methods

  def app
    path = '../../../lib/fancy_print/web_app/config.ru'
    Rack::Builder.parse_file(File.expand_path(path, __FILE__)).first
  end

  before(:all) do
    @executable = File.expand_path('../..', File.dirname(__FILE__)) +
      '/bin/fancy'
    @plot_data =
      [
       [
        [0, 2],
        [1, 4],
        [3, 3],
        [4, 17],
       ],
       [
        [5, 20],
        [6, 34],
        [7, 33],
        [8, 33.32],
        [9, 18.43],
       ],
       [
        [1, 11],
        [2, 22],
        [3, 33],
       ],
      ]
    @table_data =
      [
       ['Color Name', 'Hex Value', 'Description', 'Notes'],
       ['red', '#FF0000', 'Often used for errors.', '---'],
       ['green', '#00FF00', 'Often used for success.',
        '<p style="color: #00FF00;">I am green.</p>'],
       ['blue', '#0000FF', '---', 'Link color'],
       ['yellow', '#FFFF00', 'Often used for warnings.'],
      ]

    # Connect to the WebSocket server.
    get '/'
  end

  it 'prints a line plot to the browser' do
    Open3.popen3("#{@executable} plot '#{@plot_data}'") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints a scatter plot to the browser' do
    Open3.popen3("#{@executable} plot '#{@plot_data}' --scatter") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints a diff to the browser' do
    Open3.popen3("#{@executable} diff 'One two' 'One two three'") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints text to the browser' do
    Open3.popen3("#{@executable} text 'This is some text.'") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints HTML to the browser' do
    html = <<-HTML
<div class="row">
  <p>This is a <strong>test</strong>.</p>
</div>
HTML
    Open3.popen3("#{@executable} html '#{html}'") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints HTML to the browser (read from file)' do
    file = File.expand_path('..', File.dirname(__FILE__)) +
      '/res/html.html'
    Open3.popen3("#{@executable} html -f #{file}") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints SVG to the browser' do
    svg = <<-SVG
<svg width="5cm" height="4cm" version="1.1"
     xmlns="http://www.w3.org/2000/svg">
  <desc>Four separate rectangles
  </desc>
    <rect x="0.5cm" y="0.5cm" width="2cm" height="1cm"/>
    <rect x="0.5cm" y="2cm" width="1cm" height="1.5cm"/>
    <rect x="3cm" y="0.5cm" width="1.5cm" height="2cm"/>
    <rect x="3.5cm" y="3cm" width="1cm" height="0.5cm"/>

  <!-- Show outline of canvas using 'rect' element -->
  <rect x=".01cm" y=".01cm" width="4.98cm" height="3.98cm"
        fill="none" stroke="blue" stroke-width=".02cm" />

</svg>
SVG
    Open3.popen3("#{@executable} svg '#{svg}'") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints SVG to the browser (read from file)' do
    file = File.expand_path('..', File.dirname(__FILE__)) +
      '/res/svg.svg'
    Open3.popen3("#{@executable} svg -f #{file}") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints an image to the browser' do
    img = File.expand_path('..', File.dirname(__FILE__)) + '/res/image.png'
    Open3.popen3("#{@executable} image #{img}") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints a table to the browser (without head)' do
    Open3.popen3("#{@executable} table '#{@table_data.to_json}'") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints a table to the browser (with head)' do
    Open3.popen3("#{@executable} table '#{@table_data.to_json}' --head") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints a HAML to the browser' do
    haml = <<-HAML
%p
  This is a
  %strong HAML
  test.

%p
  Here is a list:
  %ul
    %li One
    %li Two
    %li Three
    %li Four
    %li Five
HAML
    Open3.popen3("#{@executable} haml '#{haml}'") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

  it 'prints a HAML to the browser (read from file)' do
    file = File.expand_path('..', File.dirname(__FILE__)) +
      '/res/haml.haml'
    Open3.popen3("#{@executable} haml -f '#{file}'") do
      |i, o, e, t|
      expect(o.read).to be_empty
      expect(e.read).to be_empty
    end
  end

end
