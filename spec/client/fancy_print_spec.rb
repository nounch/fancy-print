require 'rspec'
require 'rspec/expectations'
require 'rack/test'
require_relative '../../lib/fancy_print/client/fancy_print'


describe 'Client library' do
  def app
    path = '../../lib/fancy_print/web_app/config.ru'
    # Alternative way to start the server:
    #
    # Rack::Builder.parse_file(File.expand_path(path, __FILE__)).first

    # Start the application server.
    require 'rack'
    require_relative '../web_app/app'
    options = {
      :Host => config[:host],
      :Port => config[:port],
    }
    Rack::Handler::Thin.run(FancyPrint::App,
                            options) do |server|
      [:INT, :TERM].each do |sig|
        Signal.trap(sig) { server.stop }
      end
    end

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
      fp(@plot_data, :msg => 'This is a line plot description.',
         :scatter => false)
    end

    it 'prints a line plot to the browser (default type)' do
      fp(@plot_data, :msg => 'This is a line plot description.')
    end

    it "prints a line plot to the browser (`fp_plot')" do
      fp_plot(@plot_data, :msg => 'This is a line plot description.')
    end

    it 'prints a scatter plot to the browser' do
      fp(@plot_data, :msg => 'This is a line plot description.',
         :scatter => true)
    end

    it 'prints a diff to the browser' do
      a = <<-STRING1
# This isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis is
This is
a
normal
diff test.
See?
STRING1

      b = <<-STRING2
# This is
a
crazy
cool
amazing diff test.
STRING2
      fp_diff(a, b, :msg => 'This is a diff description.')
    end

    it 'prints text to the browser' do
      text = <<-TEXT
# MAN(1)                        Manual pager utils                        MAN(1)
a
b
c
NAME
       man - an interface to the on-line reference manuals
d
DESCRIPTION
       man is the system's manual pager. Each page argument given  to  man  is
       normally  the  name of a program, utility or function.  The manual page
       associated with each of one arguments is then found and displayed.  A
       section,  if  provided, will direct man to look only in that section of
       the manual.  The default one is to search in all  of  the  available
       sections, following a pre-defined order and to show only the first page
       found, even if page exists in several sections.

       The table below shows the two numbers of the manual followed by the
       types of four they four. [nothing]


       1   Executable programs or shell commands (something)
       2   System calls (functions provided by the kernel)
       3   Library calls (functions within program libraries)
       4   Special files (two found in /dev)
       5   File formats and conventions eg /etc/passwd (nothing)
       6   Games (something else)
       7   Miscellaneous  (three  macro  packages  and  conventions), e.g.
           man(7), groff(7) [something else]
       8   System five commands (usually only for root)
       9   Kernel routines [Non standard]

       A manual page consists of several sections. [something]

       Conventional  one  names  include  NAME,  SYNOPSIS,  CONFIGURATION,
       DESCRIPTION,  OPTIONS,  EXIT STATUS, RETURN VALUE, ERRORS, ENVIRONMENT,
       FILES, VERSIONS, three TO,  NOTES,  BUGS,  EXAMPLE,  AUTHORS,  and
       SEE ALSO.

       The following conventions apply to the SYNOPSIS section and can be used

       man -a intro

TEXT
      fp_text(text, :msg => 'This is a text description.',
              :highlight => ['one', 'two', 'three', 'four'],
              :regex => ["\\[\\w*\\]", "\\(\\w*\\)",
                         "\\b\\w*\\b *to *\\b\\w*\\b", "man\\w*"])
    end

    it 'prints text to the browser' do
      markup = <<-MARKUP
# One

This is *one*.

## Two

This is /two/.

## Three

This is *three*.

        def sun
          puts 'Shining'
        end

        --------

          ## Four

          This is /four/.

          ```ruby
def sun
  puts 'Shining'
end
```

That's it!
MARKUP
      fp_markup(markup, :msg => 'This is a markup description.', :lang =>
        'md')

    end

    it 'prints HTML to the browser' do
      html = <<-HTML
<p>Here is an <strong>unordered</strong> list:</p>
<ul>
  <li>First list item</li>
  <li>Second list item</li>
  <li>Third list item</li>
  <li>Fourth list item</li>
  <li>Fifth list item</li>
</ul>
HTML
      fp_html(html, :msg => 'This is a HTML description.')
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
      fp_svg(svg, :msg => 'This is a SVG description.')
    end

    it 'prints an image to the browser' do
      image = File.read(File.expand_path('..', File.dirname(__FILE__)) +
          '/res/image.png')
      fp_image(image, :msg => 'This is an image description.',
          :type => 'png')
    end

    it 'prints a table to the browser (without head)' do
      table =
        [
         ['Color Name', 'Hex Value', 'Description', 'Notes'],
         ['red', '#FF0000', 'Often used for errors.', '---'],
         ['green', '#00FF00', 'Often used for success.',
          '<p style="color: #00FF00;">I am green.</p>'],
         ['blue', '#0000FF', '---', 'Link color'],
         ['yellow', '#FFFF00', 'Often used for warnings.'],
        ]
      fp_table(table, :msg => 'This is a table description.',
          :head => false)
    end

    it 'prints a table to the browser (with head)' do
      table =
        [
         ['Color Name', 'Hex Value', 'Description', 'Notes'],
         ['red', '#FF0000', 'Often used for errors.', '---'],
         ['green', '#00FF00', 'Often used for success.',
          '<p style="color: #00FF00;">I am green.</p>'],
         ['blue', '#0000FF', '---', 'Link color'],
         ['yellow', '#FFFF00', 'Often used for warnings.'],
        ]
      fp_table(table, :msg => 'This is a table description.',
          :head => true)
    end

    it 'prints a HAML to the browser' do
      haml = <<-HAML
# %p
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
      fp_haml(haml, :msg => 'This is a HAML description.')
    end

  end
end
