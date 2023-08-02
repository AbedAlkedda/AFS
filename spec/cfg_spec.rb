# frozen_string_literal: true

require_relative '../lib/falafel'

RSpec.describe 'Chomsky with epsilon' do
  it 'Check chomsky normal form without epsilon' do
    alphabet  = %w[a b]
    vars_set  = %w[S X Y]
    start_var = 'S'
    rules     = { 'S' => [[], ['aSbS']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.epsilon_free
    cfg.chomsky_nf cfg.rules_ef

    result = cfg.chomsky_nf cfg.rules_ef

    res = { 'A' => 'a', 'B' => 'b', 'S' => %w[AH AJ AI AB], 'H' => ['SI'], 'I' => ['BS'], 'J' => ['SB'] }

    expect(result).to eq(res)
  end
end

RSpec.describe 'CYK implementing' do
  it 'CYK word problem' do
    alphabet  = %w[a b]
    vars_set  = %w[S X Y]
    start_var = 'S'
    rules     = { 'S' => [['b'], ['a'], ['aSS']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.chomsky_nf cfg.rules_ef

    check_results = { 'abb' => true, 'aaa' => true, 'aab' => true }
    check_results.each do |word, res|
      cfg.cyk_run word
      result = cfg.is_in_l
      expect(result).to eq(res)
    end
  end
end
