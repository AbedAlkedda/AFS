# frozen_string_literal: true

require_relative 'falafel'
require_relative 'pump'

d_a    = [[1, 1], [2, 2], [2, 1]]
d_b    = [[1, 2]]
states = [1, 2]
starts = [1]
finals = [1]

# d_a    = [[1, 1], [2, 1]]
# d_b    = [[1, 2]]
# states = [1, 2]
# starts = [1]
# finals = [2]

Falafel.new do |a|
  a.build d_a, d_b, states: states, starts: starts, finals: finals
  puts 'crossboss:'
  a.potens_set
  puts
  dfa = a.nfa_to_dfa
  a.dfa_to_min dfa
  puts "\nnfa to reg"
  a.nfa_to_reg
end

pump = Pump.new nil, nil, 2, 20

# a^* b^*
pump.lang = ->(w) { w.match?(/\Aa*b*\z/) }
pump.word = 'aaabbb'

puts "\nTask 1\n"
u, v, w = pump.run
puts "( \"#{pump.word}\", Zerlegung { u = \"#{u}\" , v = \"#{v}\", w = \"#{w}\"} )"

# { a^i b^j | i /= j }
pump.lang = ->(wrd) { wrd.count('a') != wrd.count('b') }
words     = %w[aaaaaabb aaaaaabbbb aaaaabbb aaabbbb aaabbbbb aabbbb]

puts "\nTask 2\n"
words.each do |word|
  pump.word = word
  u, v, w = pump.run
  puts ",( \"#{word}\", Zerlegung { u = \"#{u}\" , v = \"#{v}\", w = \"#{w}\"} )"
end

# a(aa)^*
pump.lang = ->(w) { w.match?(/a(aa)*/) }
pump.word = 'aaa'
puts "\nTask 3\n"
u, v, w = pump.run
puts "( \"#{pump.word}\", Zerlegung { u = \"#{u}\" , v = \"#{v}\", w = \"#{w}\"} )"
