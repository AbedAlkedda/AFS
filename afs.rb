# frozen_string_literal: true

require_relative 'nfa'
require_relative 'automata'

require 'awesome_print'
require 'byebug'

# d_a    = [[1, 1], [2, 3], [3, 2]]
# d_b    = [[1, 2], [2, 1], [3, 3]]
# states = [1, 2, 3]
# starts = [1]
# finals = [1]

d_a    = [[1, 1], [2, 2], [2, 1]]
d_b    = [[1, 2]]
states = [1, 2]
starts = [1]
finals = [2]

NFA.new do |a|
  a.build d_a, d_b, states, starts, finals
  puts 'crossboss'
  a.potens_set
  puts
  dfa = a.to_dfa
  a.dfa_to_min dfa
end
