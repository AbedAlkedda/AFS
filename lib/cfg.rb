# frozen_string_literal: true

# Samll CFG impletation
# Generate words and check if words are the @lang
class CFG
  attr_accessor :alphabet, :vars, :start_var, :rules
  attr_reader   :rnd_words
  attr_writer   :lang

  def initialize(alphabet, vars, start_var, rules)
    @alphabet  = alphabet
    @vars      = vars
    @start_var = start_var
    @rules     = _rules rules
    @rnd_words = []
    @lang      = ->(w) { w.count('a') == w.count('b') }
  end

  def generate_word
    word = _expand @start_var

    return unless @lang.call word

    @rnd_words << word unless @rnd_words.include? word
  end

  def chomsky
    # - neue Variablen va für a ∈ Σ und Regeln (va, a)
    # - für jede Regel (l, r) mit r ∈ (V ∪ Σ)^≥2 in r jeden
    #   Buchstaben a durch Variable va ersetzen
    # - kede Regel (l, r) mit r = r1r2 . . . rk ∈ V^k für k > 2:
    #   ersetzen durch Regeln (mit Hilfsvariablen h2, . . . , hk−1)
    #   (l, r1h2), (h2, r2h3), . . . , (hk−1, rk−1rk)
    'chom chom'
  end

  def dyck?(word)
    ->(w) { (w.count('a') - w.count('b')).zero? }.call word
  end

  private

  def _expand(symbol)
    production = @rules[symbol]

    return symbol if production.nil?

    rhs = production.sample
    rhs.map { |s| _expand(s) }.join
  end

  def _rules(rules)
    rules.each_value { |k| k.each_with_index { |item, index| k[index] = item[0].is_a?(String) ? item[0].split('') : item } }
  end

  # Chomskay start
  def _var
    'var'
  end

  def _replace_alphabet
    'replace'
  end

  def _replace_rules
    'rules'
  end
  # Chomskay end
end
