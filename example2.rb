require 'falafel'

alphabet  = %w[a b c]
vars_set  = ['S']
start_var = 'S'

rules = { 'S' => [[]] }
rules['S'] << ['aSc']
rules['S'] << ['bSc']

cfg = Falafel.new {}.cfg alphabet, vars_set, start_var, rules

# {a^x b^y c^x+y | x, y ∈ N}
reg2 = ->(w) { (w.count('a') + w.count('b') == w.count('c')) && ( w.match(/\Aa*b*c*\z/)) }

cfg.lang = reg2

100.times { cfg.generate_random }

cfg.rnd_words.sort!.each { |wrd| p wrd }
