require_relative 'lib/cfg'
require 'byebug'
require 'awesome_print'

alphabet  = %w[a b]
vars_set  = ['S']
start_var = 'S'

rules = { 'S' => [[]] }
rules['S'] << ['aSbS']

cfg = CFG.new alphabet, vars_set, start_var, rules
cfg.epsilon_clear
rr = cfg.rules_ef
rr = { 'S' => cfg.rules.values.map { |x| x.map { |y| y.join '' } }.flatten } if cfg.rules_ef.empty?
cfg.chomsky_run rr

cfg.cyk_run 'abab'
cfg.print_cyk_matrix
puts

cfg.cyk_run 'abbab'
cfg.print_cyk_matrix
puts

# puts cfg.rules
# puts cfg.rules_ef

# cfg.chomsky_as_nf cfg.rules
