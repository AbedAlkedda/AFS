# frozen_string_literal: true

require_relative 'nfa'
require_relative 'automata'

require 'byebug'

# delta_a = [[1, 2], [2, 5], [3, 1], [4, 3], [5, 4]]
# delta_b = [[2, 4], [3, 3], [4, 4], [5, 1], [5, 3]]
# states  = [1, 2, 3, 4, 5]
# start   = [1]
# finale  = [5]
# b = NFA.new delta_a, delta_b, states, start, finale

# b.to_dfa
# b.potens_set

# delta_a = [[1, 1], [2, 3], [3, 2]]
# delta_b = [[1, 2], [2, 1], [3, 3]]
# states  = [1, 2, 3]
# start   = [1]
# finale  = [1]

# nfa = NFA.new delta_a, delta_b, states, start, finale
# nfa.to_reg
# nfa.to_dfa
# nfa.potens_set

# delta_a = [[1, 1], [2, 2]]
# delta_b = [[1, 2], [2, 1]]
# states  = [1, 2]
# start   = [1]
# finale  = [1]

# nfa = NFA.new delta_a, delta_b, states, start, finale
# nfa.to_reg

d_a    = [[1, 1], [2, 2]]
d_b    = [[1, 2], [2, 1]]
states = [1, 2]
starts = [1]
finals = [1]

NFA.new do |a|
  a.build d_a, d_b, states, starts, finals
  a.to_dfa
  puts (a.power_set [1, 2, 3]).inspect
  puts (a.relation 3).inspect
  puts (a.compose [[1, 2]], [[2, 1]]).inspect
end
