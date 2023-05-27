# frozen_string_literal: true

require_relative 'nfa'
require_relative 'automata'

require 'byebug'

# d_a    = [[1, 2], [2, 5], [3, 1], [4, 3], [5, 4]]
# d_b    = [[2, 4], [3, 3], [4, 4], [5, 1], [5, 3]]
# states = [1, 2, 3, 4, 5]
# starts = [1]
# finals = [5]

d_a    = [[1, 1], [2, 3], [3, 2]]
d_b    = [[1, 2], [2, 1], [3, 3]]
states = [1, 2, 3]
starts = [1]
finals = [1]

# d_a    = [[1, 1], [2, 2]]
# d_b    = [[1, 2], [2, 1]]
# states = [1, 2]
# starts = [1]
# finals = [1]


NFA.new do |a|
  a.build d_a, d_b, states, starts, finals
  a.to_reg
end
