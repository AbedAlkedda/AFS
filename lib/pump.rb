# frozen_string_literal: true

# Pump Lemma
# It takes language as lambda function and a word as a string
# n is the length of the string you want to pump
# k is the potens of the middle word
class Pump
  attr_accessor :lang, :word

  def initialize(lang:, word:, n:, k:)
    @lang = lang
    @word = word
    @n    = n
    @k    = k
  end

  def run
    r, s, t = ''

    (0...@word.length - @n + 1).each do |i|
      r = @word[0...i]
      s = @word[i...i + @n]
      t = @word[i + @n..]

      break if s.length.positive? && (r + s * @k + t) != @word && @lang.call(r + s * @k + t)
    end

    [r, s, t]
  end
end