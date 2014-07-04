require_relative '../lib/fancy_print/client/fancy_print'

def generate_plots
  data = []
  (1..30).to_a.sample.times do |n|
    line = []
    (3..20).to_a.sample.times do |i|
      line << [i, rand(-100..00)] if rand(0..1) % 2 == 0
    end
    data << line
  end
  data
end

def test_fp
  data = generate_plots()
  fp(data, :msg => 'This is a random plot description ' + rand.to_s,
     :scatter => rand(0..1) == 1 ? true : false)
end

def test_fp_plot
  data = generate_plots()
  fp_plot(data, :msg => 'This is a random plot description ' + rand.to_s,
          :scatter => rand(0..1) == 1 ? true : false)
end

def test_fp_diff
  a = <<-STRING1
This isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis isThis is
This is
a
normal
diff test.
See?
STRING1

  b = <<-STRING2
This is
a
crazy
cool
amazing diff test.
STRING2
  fp_diff(a, b, :msg => 'This is a random diff description ' + rand.to_s)
end

def test_fp_text
  text = <<-TEXT
MAN(1)                        Manual pager utils                        MAN(1)
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
  fp_text(text, :msg => 'This is a random text description ' + rand.to_s,
          :highlight => ['one', 'two', 'three', 'four'],
          :regex => ["\\[\\w*\\]", "\\(\\w*\\)",
                     "\\b\\w*\\b *to *\\b\\w*\\b", "man\\w*"])
end

def test_fp_markup
  markup = <<-MARKUP
# One

This is *one*.

# Two

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
  fp_markup(markup, :msg => 'This is a random markup description ' +
rand.to_s, :lang => 'md')
end

def test_fp_html
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
  fp_html(html, :msg => 'This is a random HTML description ')
end

def test_fp_svg
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
  fp_svg(svg, :msg => 'This is a random SVG description ')
end

def test_fp_image
  image = File.read(File.dirname(__FILE__) + '/image.png')
  fp_image(image, :msg => 'This is a random image description ' +
           rand.to_s, :type => 'png')
end

def test_fp_table
  table =
    [
     ['Color Name', 'Hex Value', 'Description', 'Notes'],
     ['red', '#FF0000', 'Often used for errors.', '---'],
     ['green', '#00FF00', 'Often used for success.',
      '<p style="color: #00FF00;">I am green.</p>'],
     ['blue', '#0000FF', '---', 'Link color'],
     ['yellow', '#FFFF00', 'Often used for warnings.'],
    ]
  fp_table(table, :msg => 'This is a random table description ' +
           rand.to_s, :head => false)
end

def test_fp_haml
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
  fp_haml(haml, :msg => 'This is a random HAML description ' + rand.to_s)
end

testing_methods =
  [
   :test_fp,
   :test_fp_plot,
   :test_fp_haml,
   :test_fp_diff,
   :test_fp_text,
   :test_fp_markup,
   :test_fp_html,
   :test_fp_svg,
   :test_fp_image,
   :test_fp_table,
  ]
# Test random methods
# rand(0..5).times {  self.send(testing_methods.sample) }
# Test all methods
testing_methods.each { |m| self.send(m) }
