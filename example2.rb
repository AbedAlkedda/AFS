require_relative 'lib/cfg'

alphabet  = %w[a b c]
vars_set  = ['S']
start_var = 'S'

rules = { 'S' => [[]] }
rules['S'] << ['aSc']
rules['S'] << ['bSc']

cfg = CFG.new alphabet, vars_set, start_var, rules

# {a^x b^y c^x+y | x, y ∈ N}
reg2 = ->(w) { (w.count('a') + w.count('b') == w.count('c')) && (w[0] == 'a' && w[-1] == 'c' || (w[0] == 'b' && w[-1] == 'c') || w.empty? ) }

cfg.lang = reg2

100.times { cfg.generate_random }

cfg.rnd_words.sort!.each { |wrd| p wrd }

reg = ->(w) { w.count('a') + w.count('b') == w.count('c') }
