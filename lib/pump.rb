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

  def run(show_pros:)
    _clear_old_run

    r, s, t = ''

    @word.length.times do |leng|
      r, s, t = _sigma_chars leng

      pump_up_down_res = _pump_up_down_res r, s, t, show_pros
      not_in_language  = pump_up_down_res.include? false

      @is_regular = false if not_in_language

      break if not_in_language
    end

    @decomposition = [r, s, t]
  end

  private

  def _clear_old_run
    @decomposition = []
    @is_regular    = true
  end

  # ∃r, s, t ∈ Σ^∗
  def _sigma_chars(leng)
    r = @word[0...leng] || ''
    s = @word[leng...leng + @length] || ''
    t = @word[leng + @length..] || ''

    [r, s, t]
  end

  # ∀k ≥ 0 : r·s^k·t ∈ L
  def _pump_up_down_res(r, s, t, show_pros)
    pump_up_down_res = []

    20.times do |k|
      puts "r: #{r}, s: #{s}, t: #{t}, k: #{k}, r + s * k + t: #{r + s * k + t}" if show_pros
      pump_up_down_res << _pump_condtion_satisfied?(r, s, t, k)
    end

    pump_up_down_res
  end

  def _pump_condtion_satisfied?(r, s, t, k)
    (s.length.positive? && @lang.call(r + s * k + t))
  end
end
