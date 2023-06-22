# frozen_string_literal: true

# Samll CFG impletation
# Generate words and check if words are the @lang
# generates random words
class CFG
  attr_accessor :alphabet, :vars, :start_var, :rules
  attr_reader   :rnd_words, :chomsky_nf
  attr_writer   :lang

  def initialize(alphabet, vars, start_var, rules)
    @alphabet   = alphabet
    @vars       = vars
    @start_var  = start_var
    @rules      = _rules rules
    @rnd_words  = []
    @lang       = ->(w) { w.count('a') == w.count('b') }
    @chomsky_nf = {}
  end

  def generate_word
    word = _expand @start_var

    return unless @lang.call word

    @rnd_words << word unless @rnd_words.include? word
  end

  def chomsky_as_nf
    rule_name = ''

    @rules.each do |start, rl|
      rl.each do |r|
        next if r.size <= 2

        rule_name, rule_up, index,rules_new = _chomsky_nf_vars r
        lft ||= start

        2.upto(rule_up.size) do |h_num|
          rgt = "#{rule_up[index]}h#{h_num}"
          rgt = "#{rule_up[index]}#{rule_up[index + 1]}" if h_num == rule_up.size

          rules_new << "(#{lft}, #{rgt})"

          lft = "h#{h_num}"
          index += 1
        end
        _chomsky_nf_update_alphabet rules_new

        @chomsky_nf[rule_name] = rules_new
      end
    end
  end

  def epsilon_clear
    gramer = []

    @rules.each do |_, rule|
      return false unless rule.include? []

      s_rule = ''
      rule.select { |x| x unless x.empty? }.each do |sub_rule|
        s_rule = sub_rule.join ''

        (_s_index s_rule).each do |cond|
          gramer << s_rule if cond.empty?

          if cond.size == 1
            boo = sub_rule.join ''
            boo.slice!(cond[0])
            gramer << boo
          end

          next unless cond.size >= 2

          holder = sub_rule
          cond.reverse.map { |i| holder.delete_at i }
          gramer << holder.join('')
        end
      end
    end

    gramer
  end

  def dyck?(word)
    ->(w) { (w.count('a') - w.count('b')).zero? }.call word
  end

  private

  def _chomsky_nf_update_alphabet(rules_new)
    @alphabet.map { |w| "(#{w.upcase}, #{w})" }.each { |n| rules_new.unshift(n) }
  end

  def _chomsky_nf_vars(r)
    rule_name = r.join('')
    rule_up   = r.join('').upcase
    index     = 0
    rules_new = []

    [rule_name, rule_up, index, rules_new]
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
