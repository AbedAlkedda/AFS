# frozen_string_literal: true

# Pump Lemma
# It takes language as lambda function and a word as a string
# n is the length of the string you want to pump
# k is the potens of the middle word
class Pump
  attr_accessor :lang, :word
  attr_reader :is_regular

  def initialize(lang:, length:)
    @lang   = lang
    @length = length
    @word   = ''
    @k      = 20
  end

  def run()
    r, s, t = ''
    puts @word.length - @length + 1
    (0...@word.length - @length + 1).each do |i|
      r = @word[0...i]
      s = @word[i...i + @length]
      t = @word[i + @length..]

      puts "r: #{r}\ns: #{s}\nt: #{t}"

      break if s.length.positive? && (r + s * @k + t) != @word && @lang.call(r + s * @k + t)
    end

    [r, s, t]
  end
end
