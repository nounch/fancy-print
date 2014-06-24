require 'net/http'
require 'base64'


@plot_url = 'http://localhost:3044/plot'

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

def post_plot_data
  data = generate_plots()
  Net::HTTP.post_form(URI.parse(@plot_url),
                      {
                        'data' => data.to_s,
                        'description' =>
                        'This is a random plot description #' + rand.to_s,
                        'type' => rand(0..1) == 1 ? 'scatter' : 'line',
                      })
end

def post_diff_data
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

  Net::HTTP.post_form(URI.parse(@plot_url),
                      {
                        # 'a' => a + a + a + a + a + a + a + a + a + a + a +
                        # a + a + a + a + a + a + a + a + a + a + a,
                        # 'b' => b + b + b + b + b + b + b + b + b + b + b +
                        # b + b + b + b + b + b + b + b + b + b + b,
                        'a' => a,
                        'b' => b,
                        'description' =>
                        'This is a random diff description #' +
                        rand.to_s,
                        'type' => 'diff',
                      })
end

def post_text_data
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
  Net::HTTP.post_form(URI.parse(@plot_url),
                      {
                        'highlight' => '["one", "two", "three", "four"]',
                        'regex' =>
                        '["\\\\[\\\\w*\\\\]", "\\\\(\\\\w*\\\\)", "\\\\b\\\\w*\\\\b *to *\\\\b\\\\w*\\\\b", "man\\\\w*"]',
                        'text' => text,
                        'description' =>
                        'This is a random text description #' +
                        rand.to_s,
                        'type' => 'text',
                      })
end

def post_markup_data
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

        ## Four

        This is /four/.

```ruby
def sun
  puts 'Shining'
end
```

That's it!
MARKUP
  Net::HTTP.post_form(URI.parse(@plot_url),
                      {
                        'data' => markup,
                        'lang' => 'md',
                        'description' =>
                        'This is a random markup description #' +
                        rand.to_s,
                        'type' => 'markup',
                      })
end

def post_html_data
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
  Net::HTTP.post_form(URI.parse(@plot_url),
                      {
                        'data' => html,
                        'description' =>
                        'This is a random HTML description #' +
                        rand.to_s,
                        'type' => 'html',
                      })
end

def post_svg_data
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
  Net::HTTP.post_form(URI.parse(@plot_url),
                      {
                        'data' => svg,
                        'description' =>
                        'This is a random SVG description #' +
                        rand.to_s,
                        'type' => 'svg',
                      })
end

def post_image_data
  image = Base64.encode64(File.read(File.new('image.png')))
  Net::HTTP.post_form(URI.parse(@plot_url),
                      {
                        'data' => image,
                        'image_type' => 'png',
                        'description' =>
                        'This is a random image description #' +
                        rand.to_s,
                        'type' => 'image',
                      })
end

# File.write('image.html', '<img src="data:image/png;base64,' + Base64.encode64(File.read(File.new('image.png'))) + '" alt="Image"/>')

# rand(0..5).times { post_plot_data() }
# rand(0..5).times { post_diff_data() }
# rand(0..5).times { post_text_data() }
# rand(0..5).times { post_markup_data() }

# post_diff_data()
# post_text_data()
# post_markup_data()

post_methods = [
                :post_plot_data,
                :post_diff_data,
                :post_text_data,
                :post_markup_data,
                :post_html_data,
                :post_svg_data,
                :post_image_data,
               ]
rand(0..5).times {  self.send(post_methods.sample) }
