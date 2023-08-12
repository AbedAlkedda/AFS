# frozen_string_literal: true

# Pump Lemma
# It takes language as lambda function and a word as a string
# lang is a regular expression like a^*b^* given as lambda function and set by user
# word is the word to check pumping
# length is the length of the string you want to pump
# return is_regular to tell if lang is regular and decomposition to show why
class Pump
  attr_accessor :lang, :word
  attr_reader :is_regular, :decomposition

  def initialize(lang:, length:)
    @lang   = lang
    @length = length
    @word   = ''
  end

  def run()
    @decomposition = []
    @is_regular    = true

    r, s, t = ''

    @word.length.times do |leng|
      pump_up_down_res = []

      r, s, t = _sigma_chars leng
      20.times do |k|
        # puts "r: #{r}, s: #{s}, t: #{t}, k: #{k}, r + s * k + t: #{r + s * k + t}"
        pump_up_down_res << (s.length.positive? && @lang.call(r + s * k + t))
      end

      if pump_up_down_res.include? false
        @is_regular = false
        break
      end
    end
    @decomposition = [r, s, t]
  end

  private

  # ∃r, s, t ∈ Σ^∗
  def _sigma_chars(leng)
    r = @word[0...leng] || ''
    s = @word[leng...leng + @length] || ''
    t = @word[leng + @length..] || ''

    [r, s, t]
  end
end
