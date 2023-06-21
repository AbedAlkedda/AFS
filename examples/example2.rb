require 'falafel'

alphabet  = %w[a b c]
vars_set  = ['S']
start_var = 'S'

rules = { 'S' => [[]] }
rules['S'] << ['aSc']
rules['S'] << ['bSc']

falafel = Falafel.new {}
cfg     = falafel.cfg alphabet, vars_set, start_var, rules

# {a^x b^y c^x+y | x, y ∈ N}
reg2 = ->(w) { (w.count('a') + w.count('b') == w.count('c')) && w.match(/\A(a*b*c*)\z/) }

cfg.lang = reg2

# generate words
100.times { cfg.generate_word }

cfg.rnd_words.sort!.each { |wrd| p wrd }

# check if language is dyck
puts cfg.dyck? ''
puts cfg.dyck? 'a'
puts cfg.dyck? 'b'
puts cfg.dyck? 'ab'
puts cfg.dyck? 'ba'
