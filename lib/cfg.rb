# frozen_string_literal: true

# Samll CFG impletation
# Generate words and check if words are the @lang
# generates random words
class CFG
  attr_accessor :start_var, :rules
  attr_reader   :rnd_words
  attr_writer   :lang

  def initialize(start_var, rules)
    @start_var  = start_var
    @rules      = _rules rules
    @lang       = ->(w) { w.count('a') == w.count('b') } # Default reg a^nb^n
    @rnd_words  = []
    # @vars       = vars
    # @alphabet   = alphabet
    # @chomsky_nf = {}
    # @rules_ef   = {} # Rules Epsilon free

    # Cyk
    # @letter     = 'H'
    # @cyk_matrix = [[]]
  end

  def generate_word
    word = _expand @start_var

    return unless @lang.call word

    @rnd_words << word unless @rnd_words.include? word
  end

  def dyck?(word)
    ->(w) { (w.count('a') - w.count('b')).zero? }.call word
  end

  # def epsilon_clear
  #   grammer = []

  #   @rules.each do |_, rule|
  #     return false unless rule.include? []

  #     s_rule = ''
  #     rule.select { |x| x unless x.empty? }.each do |sub_rule|
  #       s_rule = sub_rule.join ''

  #       (_s_index s_rule).each do |cond|
  #         grammer << s_rule if cond.empty?

  #         if cond.size == 1
  #           new_rule = sub_rule.join ''
  #           new_rule.slice!(cond[0])
  #           grammer << new_rule
  #         end

  #         next unless cond.size >= 2

  #         holder = sub_rule.clone
  #         cond.reverse.map { |i| holder.delete_at i }
  #         grammer << holder.join('')
  #       end
  #     end
  #   end
  #   @rules_ef['S'] = grammer
  # end

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

  # def _s_index(s_rule)
  #   s_index = []
  #   s_rule.each_char.with_index { |char, index| s_index << index if char == 'S' }

  #   _power_set s_index
  # end

  # def _power_set(set)
  #   if set.empty?
  #     [[]]
  #   else
  #     element = set[0]
  #     subsets = _power_set set[1..]
  #     subsets + subsets.map { |subset| [element] + subset }
  #   end
  # end
end
