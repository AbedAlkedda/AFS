require 'falafel'

alphabet  = %w[a b c]
vars_set  = ['S']
start_var = 'S'

rules = { 'S' => [[]] }
rules['S'] << ['aSc']
rules['S'] << ['bSc']

falafel = Falafel.new {}
cfg     = falafel.cfg alphabet, vars_set, start_var, rules

cfg.epsilon_free

cfg.chomsky_nf cfg.rules_ef

puts cfg.chomsky_nf_rules

word = 'ac'
cfg.cyk_run word
puts cfg.cyk_matrix.map(&:inspect)
puts "word #{word} is #{cfg.is_in_l ? '' : 'not '}in CFL"
