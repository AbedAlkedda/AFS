# frozen_string_literal: true

require_relative 'automata'

# DFA class
class DFA < Automata
  attr_accessor :delta_star, :states, :finals, :start

  def to_min
    puts @finals.inspect
  end
end
