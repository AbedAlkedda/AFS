# frozen_string_literal: true

require_relative 'dfa'
require_relative 'automata'

# NFA class
class NFA < Automata
  def to_dfa
    dfa = nfa_to_dfa

    puts "nfa:\n\nfinals: #{dfa.finals.map { |ele| _concat(ele).to_i }}"
    puts "states: #{dfa.states.map(&:to_i)}"
    dfa.delta_star.each { |k, v| v.each { |e| puts "(#{e[0]} ,'#{k}', #{e[1]})" } }

    dfa
  end
end
