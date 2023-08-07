# frozen_string_literal: true

require 'falafel'

alphabet  = %w[a b]
vars_set  = %w[S]
start_var = 'S'

rules = { 'S' => [['b'], ['a'], ['aSS']] }

falafel = Falafel.new {}
cfg     = falafel.cfg alphabet, vars_set, start_var, rules

cfg.chomsky_nf nil

word = 'aabaabb'

cfg.cyk_run word
puts cfg.cyk_matrix.map(&:inspect)
puts "word #{word} is #{cfg.is_in_l ? '' : 'not '}in CFL"
