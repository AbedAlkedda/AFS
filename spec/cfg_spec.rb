# frozen_string_literal: true

require_relative '../lib/falafel'

RSpec.describe 'CYK implementing 0' do
  it 'CYK word problem with epsilon' do
    alphabet  = %w[a b]
    vars_set  = %w[S]
    start_var = 'S'
    rules     = { 'S' => [[], ['aSbS']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.epsilon_free
    cfg.chomsky_nf cfg.rules_ef

    check_results = { 'ab' => true, 'aabb' => true, 'aabbb' => false }

    check_results.each do |word, res|
      cfg.cyk_run word
      result = cfg.is_in_l
      expect(result).to eq(res)
    end
  end
end

RSpec.describe 'CYK implementing 1' do
  it 'CYK word problem without any special cases' do
    alphabet  = %w[a b]
    vars_set  = %w[S]
    start_var = 'S'
    rules     = { 'S' => [['a'], ['b'], ['aSS']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.chomsky_nf cfg.rules_ef

    check_results = { 'aba' => true, 'aaa' => true, 'abb' => true, 'abbb' => false }
    check_results.each do |word, res|
      cfg.cyk_run word
      result = cfg.is_in_l
      expect(result).to eq(res)
    end
  end
end

RSpec.describe 'CYK implementing 2' do
  it 'CYK word problem without any special cases 2' do
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
  it 'CYK word problem with epsilon' do
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
    x = 13
    y = 13
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

RSpec.describe 'CYK implementing 4' do
  it 'CYK word problem with epsilon (complicated)' do
    alphabet  = %w[a b]
    vars_set  = %w[S X Y]
    start_var = 'S'
    rules = { 'S' => [[], ['aSS'], ['SaY'], ['a']] }
    rules['X'] = [['aX'], []]
    rules['Y'] = [['bY'], []]

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.epsilon_free

    cfg.chomsky_nf cfg.rules_ef

    check_results = { 'aaa' => true, 'aab' => true }

    check_results.each do |word, res|
      cfg.cyk_run word
      result = cfg.is_in_l
      expect(result).to eq(res)
    end
  end
end
