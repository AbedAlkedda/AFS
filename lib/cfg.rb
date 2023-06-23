# frozen_string_literal: true

# Samll CFG impletation
# Generate words and check if words are the @lang
# generates random words
class CFG
  attr_accessor :alphabet, :vars, :start_var, :rules
  attr_reader   :rnd_words, :chomsky_nf, :rules_ef
  attr_writer   :lang

  def initialize(alphabet, vars, start_var, rules)
    @alphabet   = alphabet
    @vars       = vars
    @start_var  = start_var
    @rules      = _rules rules
    @rnd_words  = []
    @lang       = ->(w) { w.count('a') == w.count('b') } # Default reg a^nb^n
    @chomsky_nf = {}
    @rules_ef   = {} # Rules Epsilon free
    @letter     = 'H'
  end

  def generate_word
    word = _expand @start_var

    return unless @lang.call word

    @rnd_words << word unless @rnd_words.include? word
  end

  def epsilon_clear
    grammer = []

    @rules.each do |_, rule|
      return false unless rule.include? []

      s_rule = ''
      rule.select { |x| x unless x.empty? }.each do |sub_rule|
        s_rule = sub_rule.join ''

        (_s_index s_rule).each do |cond|
          grammer << s_rule if cond.empty?

          if cond.size == 1
            new_rule = sub_rule.join ''
            new_rule.slice!(cond[0])
            grammer << new_rule
          end

          next unless cond.size >= 2

          holder = sub_rule.clone
          cond.reverse.map { |i| holder.delete_at i }
          grammer << holder.join('')
        end
      end
    end
    @rules_ef['S'] = grammer
  end

  def chomsky_run(rules)
    @res = {}
    rules['S'].each do |r|
      @res[r] = _chomsky_as_nf(r)
    end

    puts @res
  end

  def dyck?(word)
    ->(w) { (w.count('a') - w.count('b')).zero? }.call word
  end

  private

  def _chomsky_as_nf(rule)
    return {} if rule.size <= 2

    rules_new = _build_chomsky rule
    _check_loop rules_new

    rules_new
  end

  def _chomsky_rgt(rule_up, index, h_num)
    rgt     = "#{rule_up[index]}#{@letter}"
    rgt     = "#{rule_up[index]}#{rule_up[index + 1]}" if h_num == rule_up.size
    @letter = @letter.succ

    rgt
  end

  def _build_chomsky(rule)
    rule_up, index, rules_new = _chomsky_nf_vars rule
    lft ||= 'S'

    2.upto(rule_up.size) do |h_num|
      rgt = _chomsky_rgt rule_up, index, h_num
      rules_new << { lft.to_s => rgt }
      lft    = (@letter.ord - 1).chr
      index += 1
    end

    rules_new
  end

  def _check_loop(rules_new)
    @res.each do |_, solutions|
      solutions.each do |solution|
        solution.each do |sol_key, sol_val|
          rules_new.each_with_index do |rule, index|
            rule.each do |rul_key, rul_val|
              rule.delete(rul_key) if rul_val == sol_val
              rules_new[index - 1].values[0][1] = sol_key if rul_val == sol_val
            end
          end
        end
      end
    end
  end

  def _chomsky_nf_vars(r)
    rule_up   = r.upcase
    index     = 0
    rules_new = []

    [rule_up, index, rules_new]
  end

  def _expand(symbol)
    production = @rules[symbol]

    return symbol if production.nil?

    rhs = production.sample # pcik up a random element from array
    rhs.map { |s| _expand(s) }.join
  end

  def _rules(rules)
    rules.each_value { |k| k.each_with_index { |item, index| k[index] = item[0].is_a?(String) ? item[0].split('') : item } }
  end

  def _s_index(s_rule)
    s_index = []
    s_rule.each_char.with_index { |char, index| s_index << index if char == 'S' }

    _power_set s_index
  end

  def _power_set(set)
    if set.empty?
      [[]]
    else
      element = set[0]
      subsets = _power_set set[1..]
      subsets + subsets.map { |subset| [element] + subset }
    end
  end
end
