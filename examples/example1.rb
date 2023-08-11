# frozen_string_literal: true

require 'falafel'

d_a    = [[1, 1], [2, 2], [2, 1]]
d_b    = [[1, 2]]
states = [1, 2]
starts = [1]
finals = [1]

Falafel.new do |a|
  a.build d_a, d_b, states: states, starts: starts, finals: finals
  puts 'crossboss:'
  a.potens_set
  puts
  dfa = a.nfa_to_dfa
  a.dfa_to_min dfa
  puts "\nnfa to reg matrix"
  reg = a.nfa_to_reg
  reg.print_matrix
  puts "\nnfa to reg: #{reg.final_reg}"
end
