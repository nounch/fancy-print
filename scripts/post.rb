require 'net/http'


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
                        'a' => a,
                        'b' => b,
                        'description' =>
                        'This is a random diff description #' +
                        rand.to_s,
                        'type' => 'diff',
                      })
end

rand(0..5).times { post_plot_data() }
rand(0..5).times { post_diff_data() }

# DEBUG
# require 'pp'
# pp data
