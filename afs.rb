# frozen_string_literal: true

require_relative 'NFA'
require 'byebug'

# a = NFA.new([[1, 2], [2, 3], [3, 1]], # delta a
#             [[1, 1], [1, 3], [3, 3]], # delta b
#             [1, 2, 3],                # states set
#             [1, 2, 3])                # finals set

delta_a = [[1, 2], [2, 5], [3, 1], [4, 3], [5, 4]]
delta_b = [[2, 4], [3, 3], [4, 4], [5, 1], [5, 3]]
states  = [1, 2, 3, 4, 5]
start   = [1]
finale  = [5]

b = NFA.new delta_a, delta_b, states, start, finale

b.to_dfa
# b.potens_set
