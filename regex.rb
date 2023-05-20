# frozen_string_literal: true

# Regex string builder
class Regex
  def self.new
    instance = allocate
    yield instance

    instance
  end

  def run(regex, max)
    @regex = regex
    @res   = []

    string = ''
    100_000.times do
      string = _generate_string max
      @res << string unless @res.include? string
    end
  end

  def print
    puts @res
  end

  def save
    File.open('langs.txt', 'a') do |f|
      unless @res.empty?
        f.write "size: #{@res[0].length}\n"
        @res.each { |w| f.write "#{w}\n" }
      end
    end
  end

  private

  def _generate_string(max)
    string = (0...max).map { ('a'..'b').to_a[rand(2)] }.join while string !~ @regex

    string
  end
end

0..30.times do |m|
  Regex.new do |x|
    x.run(/^(a|b)*b(a|b){2}$/, m + 3)
    x.print
    x.save
  end
end
