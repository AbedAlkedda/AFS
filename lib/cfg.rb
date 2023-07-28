# frozen_string_literal: true

require_relative 'epsilon_free'

# Samll CFG impletation
# Generate words and check if words are the @lang
# generates random words
class CFG
  attr_accessor :start_var, :rules
  attr_reader   :rnd_words, :reachables, :rules_ef, :rules_cf

  def initialize(alphabet, vars, start_var, rules)
    @start_var  = start_var
    @rules      = _rules rules
    @rnd_words  = []
    @reachables = []
    @vars       = vars
    @rules_ef   = {}

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
    @rules_ef = EpsilonFree.new.run @rules
  end

  def chaining_free
    c_r = _chaining_relation

    # build transivity relation from _chaining_relation(K) as A
    # remove _chaining_relation from rules
    @rules_cf = (_rebuild_rules - c_r) + c_r.map { |r| _transitivity_relation r }.reduce(:concat)
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

  # chaining_free start
  def _chaining_relation
    rules = _rebuild_rules

    rules & @vars.product(@vars)
  end

  def _rebuild_rules
    result = []
    @rules.each do |var, rule|
      rule.map do |r|
        result << [var, r.join]
      end
    end

    result
  end

  def _transitivity_relation(pair)
    transitive_relation = [pair]
    loop do
      new_pairs = []

      _rebuild_rules.each do |a, b|
        next unless pair[1] == a && !transitive_relation.include?([pair[0], b])

        new_pairs << [pair[0], b]
      end

      break if new_pairs.empty?

      transitive_relation.concat(new_pairs)
    end

    transitive_relation
  end

  def _new_pairs(rules)
    rules.each do |a, b|
      next unless pair[1] == a && !transitive_relation.include?([pair[0], b])

      new_pairs << [pair[0], b]
    end
  end
  # chaining_free end

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
end
