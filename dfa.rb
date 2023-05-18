# frozen_string_literal: true

# DFA class
class DFA
  attr_accessor :delta_star, :state_set, :finals, :start

  def initialize(delta_a, delta_b, state_set, start, finals)
    # Q, I, F, delta
    @delta_star = { a: delta_a, b: delta_b }
    @state_set  = state_set
    @finals     = finals
    @start      = start
  end
end
