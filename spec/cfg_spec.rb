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

    cfg.epsilon_free nil
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

    cfg.epsilon_free nil
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

    cfg.epsilon_free nil

    cfg.chomsky_nf cfg.rules_ef

    check_results = { 'aaa' => true, 'aab' => true }

    check_results.each do |word, res|
      cfg.cyk_run word
      result = cfg.is_in_l
      expect(result).to eq(res)
    end
  end
end

RSpec.describe 'CYK implementing 5' do
  it 'CYK word problem with chaining and Epsilon' do
    alphabet  = %w[a b]
    vars_set  = %w[S X Y]
    start_var = 'S'
    rules = { 'S' => [['X'], ['Y']], 'X' => [[], ['aX']], 'Y' => [[], ['bY']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.chaining_free

    cfg.epsilon_free cfg.rules_cf

    cfg.chomsky_nf cfg.rules_ef

    check_results = { 'a' * 10 => true, 'aaa' => true, 'bbb' => true, 'bbba' => false }

    check_results.each do |word, res|
      cfg.cyk_run word
      result = cfg.is_in_l
      expect(result).to eq(res)
    end
  end
end

RSpec.describe 'CYK implementing 5' do
  it 'CYK word problem with chaining' do
    alphabet  = %w[a b]
    vars_set  = %w[S X Y]
    start_var = 'S'
    rules = { 'S' => [['X'], ['Y'], ['a']], 'X' => [['aX']], 'Y' => [['bY']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.chaining_free

    cfg.chomsky_nf cfg.rules_cf

    check_results = { 'a' * 10 => false,
                      'aaa' => false,
                      'bbb' => false,
                      'bbba' => false
                    }

    check_results.each do |word, res|
      cfg.cyk_run word
      result = cfg.is_in_l
      expect(result).to eq(res)
    end
  end
end

RSpec.describe 'CYK implementing 6' do
  it 'CYK word problem with chaining' do
    alphabet  = %w[a b]
    vars_set  = %w[S X Y]
    start_var = 'S'
    rules = { 'S' => [['X'], ['Y']], 'X' => [['aX'], ['a']], 'Y' => [['bY']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.chaining_free

    cfg.chomsky_nf cfg.rules_cf

    check_results = { 'a' * 10 => true,
                      'a' * 20 => true,
                      'bbb' => false,
                      'aaaaaab' => false }

    check_results.each do |word, res|
      cfg.cyk_run word
      result = cfg.is_in_l
      expect(result).to eq(res)
    end
  end
end

RSpec.describe 'Pumping Lemma 1' do
  it 'Language a^* b^*' do
    pump       = Falafel.new {}
    lang       = ->(w) { w.match?(/\Aa*b*\z/) }
    length     = 3
    pump_lemma = pump.pump_lemma lang, length

    check_results = {
      'aaaaa' => true,
      'aaaab' => false,
      'aaab' => false,
      'aabb' => false,
      'abb' => false
    }

    check_results.each do |word, res|
      pump_lemma.word = word
      pump_lemma.run show_pros: false
      pump_lemma.is_regular
      expect(pump_lemma.is_regular).to eq(res)
    end
  end
end
