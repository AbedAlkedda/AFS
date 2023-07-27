# frozen_string_literal: true

# Samll CFG impletation
# Generate words and check if words are the @lang
# generates random words
class CFG
  attr_accessor :start_var, :rules
  attr_reader   :rnd_words, :reachables, :rules_ef

  def initialize(alphabet, vars, start_var, rules)
    @start_var  = start_var
    @rules      = _rules rules
    @rnd_words  = []
    @reachables = []
    @vars       = vars
    @rules_ef   = {} # Rules Epsilon free
    # @alphabet   = alphabet
    # @chomsky_nf = {}

    # Cyk
    # @letter     = 'H'
    # @cyk_matrix = [[]]
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

  def epsilon_clear
    epsilon = _epsilon

    return if epsilon.empty?

    epsilon.each do |e_class|
      cleared_rules     = _cleared_rules @rules[e_class]
      epsilon_free_word = cleared_rules.join ''
      grammer           = _grammer_epsilon_free epsilon_free_word, cleared_rules, e_class

      @rules_ef[e_class] = grammer
    end
  end

  # def chomsky_run(rules)
  #   @res = {}

  #   rules['S'].each { |r| @res[r] = _chomsky_as_nf r }

  #   _build_chomsky_nf
  # end

  # def cyk_run(word)
  #   @cyk_matrix = _cyk_fill_diagonal word

  #   _cyk
  # end

  # def print_cyk_matrix
  #   puts @cyk_matrix.map(&:inspect)
  # end

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

  # def _chomsky_as_nf(rule)
  #   return {} if rule.size <= 2

  #   rules_new = _build_chomsky rule
  #   _check_loop rules_new

  #   rules_new
  # end

  # def _chomsky_rgt(rule_up, index, h_num)
  #   rgt     = "#{rule_up[index]}#{@letter}"
  #   rgt     = "#{rule_up[index]}#{rule_up[index + 1]}" if h_num == rule_up.size
  #   @letter = @letter.succ

  #   rgt
  # end

  # def _build_chomsky(rule)
  #   rule_up, index, rules_new = _chomsky_nf_vars rule
  #   lft ||= 'S'

  #   2.upto(rule_up.size) do |h_num|
  #     rgt = _chomsky_rgt rule_up, index, h_num
  #     rules_new << { lft.to_s => rgt }
  #     lft    = (@letter.ord - 1).chr
  #     index += 1
  #   end

  #   rules_new
  # end

  # def _build_chomsky_nf
  #   # build Chomsky-Nf mit Nachnutzen von Hilfsvariablen
  #   @chomsky_nf['alphabet']  = @alphabet
  #   @chomsky_nf['hlp_vars']  = _build_chomsky_nf_hlp_vars
  #   @chomsky_nf['start_var'] = 'S'
  #   @chomsky_nf['rules']     = _build_chomsky_nf_rules
  #   @chomsky_nf['hlp_hash']  = _build_chomsky_nf_hlp_hash
  # end

  # def _build_chomsky_nf_hlp_vars
  #   hlp_vars = %w[A B]
  #   hlp_vars << @res.values.flatten.reject(&:empty?).map(&:keys).flatten.uniq

  #   hlp_vars.flatten
  # end

  # def _build_chomsky_nf_rules
  #   res = @res.values.flatten.reject(&:empty?)
  #   res << { 'A' => 'a' }
  #   res << { 'B' => 'b' }
  #   start_var = @res.keys.select { |x| x.size <= 2 }.select { |x| x == @alphabet.join('') }

  #   unless start_var.empty?
  #     start_var = start_var[0].upcase
  #     res << { 'S' => start_var }
  #   end

  #   res
  # end

  # def _build_chomsky_nf_hlp_hash
  #   res = {}
  #   i = 0
  #   @chomsky_nf['hlp_vars'].each do |h|
  #     next if h == 'S'

  #     res[i] = h
  #     i += 1
  #   end

  #   res
  # end

  # def _check_loop(rules_new)
  #   @res.each do |_, solutions|
  #     solutions.each do |solution|
  #       solution.each do |sol_key, sol_val|
  #         rules_new.each_with_index do |rule, index|
  #           rule.each do |rul_key, rul_val|
  #             rule.delete(rul_key) if rul_val == sol_val
  #             rules_new[index - 1].values[0][1] = sol_key if rul_val == sol_val
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

  # def _chomsky_nf_vars(r)
  #   rule_up   = r.is_a?(Array) ? r : r.upcase
  #   index     = 0
  #   rules_new = []

  #   [rule_up, index, rules_new]
  # end

  # def _cyk_fill_diagonal(word)
  #   wrd_lng = word.length
  #   table = Array.new(wrd_lng) { Array.new(wrd_lng) { [] } }
  #   (0..wrd_lng - 1).each do |index|
  #     table[index][index] = word[index].upcase
  #   end

  #   table
  # end

  # def _cyk
  #   @cyk_matrix.size.times do |limiter|
  #     (0...@cyk_matrix.length - limiter).each do |i|
  #       j = i + limiter

  #       next if i == j

  #       p_, q_ = _cyk_p_q i, j

  #       rule = "#{p_}#{q_}"

  #       @cyk_matrix[i][j] = _cyk_new_matrix_val rule
  #     end
  #   end
  # end

  # def _cyk_p_q(i, j)
  #   h_   = j - 1
  #   h_  -= 1 until @chomsky_nf['hlp_hash'].values.include? @cyk_matrix[i][h_]
  #   p_   = @cyk_matrix[i][h_]
  #   q_   = @cyk_matrix[h_ + 1][j]

  #   [p_, q_]
  # end

  # def _cyk_new_matrix_val(rule)
  #   val = @chomsky_nf['rules'].select { |hash| hash.value?(rule) }&.first&.key(rule)
  #   val ||= '∅ '

  #   val
  # end

  # epsilon free start
  def _build_possibilities(s_rule)
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

  def _epsilon
    res = @rules.map do |var, rules|
      next unless rules.include? []

      var
    end
    res.reject(&:nil?)
  end

  def _cleared_rules(rules)
    rules.reject(&:empty?)
  end

  def _remove_e_class(possibility, cleared_rules)
    return cleared_rules.join '' if possibility.empty?

    new_rule = cleared_rules.join ''
    possibility.reverse.each { |index| new_rule.slice! index }

    new_rule
  end

  def _grammer_epsilon_free(epsilon_free_word, cleared_rules, e_class)
    possibilities = _build_possibilities epsilon_free_word

    res = possibilities.map do |possibility|
      _remove_e_class possibility, cleared_rules
    end

    res << epsilon_free_word.delete(e_class) if possibilities.size == 1

    res
  end
  # epsilon free end
end
