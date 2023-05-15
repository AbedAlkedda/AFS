require_relative 'NFA'
require 'byebug'

# a = NFA.new([[1, 2], [2, 3], [3, 1]], # delta a
#             [[1, 1], [1, 3], [3, 3]], # delta b
#             [1, 2, 3],                # states set
#             [1, 2, 3])                # finals set

b = NFA.new([[1, 2], [2, 5], [3, 1], [4, 3], [5, 4]],
            [[2, 4], [3, 3], [4, 4], [5, 1], [5, 3]],
            [1, 2, 3, 4, 5],
            [5])


b.clean_format
b.finals_set
# b.autotool_format

# c = NFA.new([[3, 2], [4, 1], [4, 5], [5, 3]],
#   [[1, 3], [2, 4], [3, 1], [3, 2], [3, 5], [4, 3]],
#   [1, 2, 3, 4, 5],
#   [4])

# c.clean_format
# c.finals_set
# c.autotool_format

# d = NFA.new([[0, 1], [1, 1]],
#   [[1, 1], [1, 2]],
#   [0, 1, 2],
#   [2])

# d.clean_format
# d.finals_set
# b.autotool_format
