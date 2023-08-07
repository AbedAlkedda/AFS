# frozen_string_literal: true

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

puts "Chomksy normal form: #{cfg.rules_ef_res}"

cfg.chomsky_nf cfg.rules_ef

word = 'aaaabbbbcccccccc'
cfg.cyk_run word
puts cfg.cyk_matrix.map(&:inspect)
puts "word #{word} is #{cfg.is_in_l ? '' : 'not '}in CFL"
