# frozen_string_literal: true

require_relative 'cyk'
require_relative 'chomsky_nf'
require_relative 'chomsky_helper/epsilon_free'
require_relative 'chomsky_helper/chaining_free'

# Samll CFG impletation
# Generate words and check if words are the @lang
# generates random words
class CFG
  attr_accessor :start_var, :rules
  attr_reader   :rules_ef,     :rules_cf,     :rnd_words,
                :rules_ef_res, :rules_cf_res, :chomsky_nf_rules,
                :cyk_matrix,   :is_in_l

  def initialize(alphabet, vars, start_var, rules)
    @start_var  = start_var
    @rules      = _rules rules
    @rnd_words  = []
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

  def epsilon_free(custom_rule)
    e_free        = ChomskyHelper::EpsilonFree.new
    @rules_ef_res = e_free.run custom_rule || @rules
    @rules_ef     = e_free.rebuild_rules @rules, @rules_ef_res
  end

  def chaining_free
    c_free        = ChomskyHelper::ChainingFree.new
    @rules_cf_res = c_free.run @rules, @vars
    @rules_cf     = c_free.rebuild_rules @rules_cf_res
  end

  def chomsky_nf(custom_rule)
    chomsky = ChomskyNF.new
    rules   = chomsky.run custom_rule || @rules, @alphabet

    @chomsky_nf_rules = chomsky.simplify rules
  end

  def cyk_run(word)
    cyk = CYK.new word, @chomsky_nf_rules

    cyk.run

    @cyk_matrix = cyk.matrix
    @is_in_l    = cyk.is_in_l
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
