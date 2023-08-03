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

RSpec.describe 'CYK implementing 2' do
  it 'CYK word problem 2' do
    alphabet  = %w[a b]
    vars_set  = %w[S X Y]
    start_var = 'S'
    rules     = { 'S' => [['b'], ['aSS']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.chomsky_nf cfg.rules_ef

    check_results = { 'ababb' => true, 'abbab' => false }
    check_results.each do |word, res|
      cfg.cyk_run word
      result = cfg.is_in_l
      expect(result).to eq(res)
    end
  end
end

RSpec.describe 'CYK implementing 3' do
  it 'CYK word problem 3' do
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
    x = 311
    y = 311
    z = x + y
    check_results = { 'ac' => true,
                      'abcc' => true,
                      "#{'a' * x}#{'b' * y}#{'c' * z}" => true }
    check_results.each do |word, res|
      cfg.cyk_run word
      result = cfg.is_in_l
      expect(result).to eq(res)
    end
  end
end
