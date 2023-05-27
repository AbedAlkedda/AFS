# frozen_string_literal: true

require_relative 'automata'

# DFA class
class DFA < Automata
  attr_accessor :delta_star, :states, :finals, :start

  def to_min
    finals = _finals
    states = _states
    r0     = _r0 finals, states

    puts
    puts r0.inspect
  end

  private

  def _finals
    @finals.map { |f| f.join('').to_i }
  end

  def _r0(finals, states)
    (@states - (@states & finals))
    r0 = []
    @states.each_with_index do |p, _|
      @states.each_with_index do |q, _|
        r0 << [states[p], states[q]] if finals.include?(p) == finals.include?(q)
      end
    end

    r0
  end

  def _states
    ltr = 'p'
    _swap_for_demo

    @states.each_with_object({}) do |elt, memo|
      memo[elt] = ltr
      ltr       = ltr.succ
    end
  end

  def _swap_for_demo
    r = @states[1]
    h = r
    @states[1] = @states[2]
    @states[2] = h
  end
end
