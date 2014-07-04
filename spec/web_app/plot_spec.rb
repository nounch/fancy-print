require 'rspec'
require 'rspec/expectations'
require 'rack/test'
require 'json'

require_relative '../../lib/fancy_print/web_app/app'


describe 'WebSocket component' do
  include Rack::Test::Methods

  def app
    path = '../../../lib/fancy_print/web_app/config.ru'
    Rack::Builder.parse_file(File.expand_path(path, __FILE__)).first
  end

  describe 'Post output' do
    before(:all) do
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
    end

    it 'prints a line plot to the browser (explicite type)' do
      post('/plot',
           {
             :data => @plot_data.to_json,
             :type => 'line',
             :description => 'This is a line plot description.'
           })
    end

    it 'prints a line plot to the browser (default type)' do
      post('/plot',
           {
             :data => @plot_data.to_json,
             :description => 'This is a line plot description.'
           })
    end

    it 'prints a scatter plot to the browser' do
      post('/plot',
           {
             :data => @plot_data.to_json,
             :type => 'scatter',
             :description => 'This is a scatter plot description.'
           })
    end

    it 'prints a diff to the browser' do
      a = <<-ASTRING
This is
a
simple
test.
ASTRING

      b = <<-BSTRING
This is
a not so simple
and very crazy
test.
BSTRING

      post('/plot',
           {
             :a => a,
             :b => b,
             :type => 'diff',
             :description => 'This is a diff description.'
           })
    end

    it 'prints text to the browser' do
      text = <<-TEXT
This is some text, just for you.

Here are some numbers:

- one
- two
- three
- four

That's it. Thanks.
TEXT

      post('/plot',
           {
             :highlight => ['one', 'two', 'three', 'four'].to_json,
             :regex => ["\\[\\w*\\]", "\\(\\w*\\)",
                        "\\b\\w*\\b *to *\\b\\w*\\b", "man\\w*"].to_json,
             :text => text,
             :type => 'text',
             :description => 'This is a text description.',
           })
      expect(last_response).to be_ok
    end

    it 'prints markup to the browser' do
      markdown = <<-MARKDOWN
# One

Here is some code:

        def sun
          puts 'Shining
        end

## Two

This is number *two*.

## Three

This is number **three**.

MARKDOWN
      post('/plot',
           {
             :data => markdown,
             :type => 'markup',
             :lang => 'md',
             :description => 'This is a text description.',
           })
      expect(last_response).to be_ok
    end

    it 'prints HTML to the browser' do
      html = <<-HTML
<div class="row">
  <p>This is a <strong>test</strong>.</p>
</div>
HTML
      post('/plot',
           {
             :data => html,
             :type => 'html',
             :description => 'This is a HTML description.',
           })
      expect(last_response).to be_ok
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
      post('/plot',
           {
             :data => svg,
             :type => 'svg',
             :description => 'This is a SVG description.',
           })
      expect(last_response).to be_ok
    end

    it 'prints an image to the browser' do
      image = File.read(File.expand_path('..', File.dirname(__FILE__)) +
        '/res/image.png')
      post('/plot',
           {
             :data => image,
             :img_type => 'png',
             :type => 'image',
             :description => 'This is an image description.',
           })
      expect(last_response).to be_ok
    end

    it 'prints a table to the browser (without head)' do
      post('/plot',
           {
             :data => @table_data.to_json,
             :head => 'false',
             :type => 'table',
             :description => 'This is a table description.',
           })
      expect(last_response).to be_ok
    end

    it 'prints a table to the browser (with head)' do
      post('/plot',
           {
             :data => @table_data.to_json,
             :head => 'true',
             :type => 'table',
             :description => 'This is a table description.',
           })
      expect(last_response).to be_ok
    end

    it 'prints HAML to the browser' do
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
      post('/plot',
           {
             :data => haml,
             :type => 'haml',
             :description => 'This is a HAML description.',
           })
      expect(last_response).to be_ok
    end
  end
end
