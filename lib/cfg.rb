# frozen_string_literal: true

require_relative 'cyk'
require_relative 'chomsky_nf'
require_relative 'epsilon_free'
require_relative 'chaining_free'

# Samll CFG impletation
# Generate words and check if words are the @lang
# generates random words
class CFG
  attr_accessor :start_var, :rules
  attr_reader   :rules_ef, :rules_cf, :rnd_words, :reachables,
                :rules_ef_res, :rules_cf_res, :chomksy_nf_rules

  def initialize(alphabet, vars, start_var, rules)
    @start_var  = start_var
    @rules      = _rules rules
    @rnd_words  = []
    @reachables = []
    @vars       = vars
    @alphabet   = alphabet
  end

  def generate_words(count)
    @rnd_words = []

    loop do
      word = _expand @start_var

      @rnd_words << word unless @rnd_words.include? word

      break if @rnd_words.size == count
    end
  end

  def var_reachable?
    @rules[@start_var].each do |rule|
      @vars.each { |var| @reachables << var if rule.include? var }
    end
    @reachables.uniq!
  end

  def var_productive?
    ''
  end

  def var_reduced?
    ''
  end

  def epsilon_free
    e_free        = EpsilonFree.new
    @rules_ef_res = e_free.run @rules
    @rules_ef     = e_free.rebuild_rules @rules, @rules_ef_res
  end

  def chaining_free
    c_free        = ChainingFree.new
    @rules_cf_res = c_free.run @rules, @vars
    @rules_cf     = c_free.rebuild_rules @rules_cf_res
  end

  def chomksy_nf(custom_rule)
    chomksy = ChomskyNF.new

    @chomksy_nf_rules = chomksy.run custom_rule || @rules, @alphabet
  end

  def cyk_run(word)
    cyk = CYK.new word, chomksy_nf_rules

    matrix = cyk.run

    puts matrix.map(&:inspect)
  end

  private

  def _rules(rules)
    rules.each_value { |k| k.each_with_index { |item, index| k[index] = item[0].is_a?(String) ? item[0].split('') : item } }
  end

  def _expand(symbol)
    production = @rules[symbol]

    return symbol if production.nil?

    rhs = production.sample # pick up a random element from array

    rhs.map { |s| _expand(s) }.join
  end
end
