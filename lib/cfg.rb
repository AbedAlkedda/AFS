class CFG
  attr_accessor :alphabet, :vars, :start_var, :rules
  attr_reader   :rnd_words
  attr_writer   :lang

  def initialize(alphabet, vars, start_var, rule)
    @alphabet  = alphabet
    @vars      = vars
    @start_var = start_var
    @rules     = _rules rule
    @rnd_words = []
  end

  def generate_random
    word = _expand @start_var

    # return unless _in_lang? word

    @rnd_words << word unless @rnd_words.include? word
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

  def _in_lang?(word)
  end

end
