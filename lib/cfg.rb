# frozen_string_literal: true

require_relative 'epsilon_free'
require_relative 'chaining_free'

# Samll CFG impletation
# Generate words and check if words are the @lang
# generates random words
class CFG
  attr_accessor :start_var, :rules
  attr_reader   :rules_ef, :rules_cf, :rnd_words, :reachables,
                :rules_ef_res, :rules_cf_res

  def initialize(alphabet, vars, start_var, rules)
    @start_var  = start_var
    @rules      = _rules rules
    @rnd_words  = []
    @reachables = []
    @vars       = vars
    @alphabet   = alphabet

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

  def chomksy_nf
    # generate new vars 'a ∈ Σ und Regeln (va, a)'
    new_rules = {}

    # add cases like (A, a), (B, b)
    _add_single_vars new_rules

    # change rules like (X, aX) to (X, AX)
    _handle_simple_rule new_rules

    _handle_all_rule new_rules

    puts new_rules.inspect
  end

  # def cyk_run(word)
  #   @cyk_matrix = _cyk_fill_diagonal word

  #   _cyk
  # end

  # def print_cyk_matrix
  #   puts @cyk_matrix.map(&:inspect)
  # end

  private

  # chomksy_nf start
  def _add_single_vars(new_rules)
    @rules.values.reduce(:concat).each do |rule|
      rule.select { |var| var == var.downcase }.each do |r|
        new_rules[r] = r.upcase
      end
    end
  end

  def _handle_simple_rule(new_rules)
    @rules.each do |var, rule|
      new_rules[var] = []
      rule.each do |r|
        next if r.empty?

        new_rules[var] << r.map(&:upcase)
      end
    end
  end

  def _handle_all_rule(new_rules)
    new_rules_buffer = {}

    new_rules.each do |var, rules|
      next if _is_character? rules

      new_rules_buffer = _new_rules_buffer rules, var
    end

    new_rules.merge! new_rules_buffer
  end

  def _find_letter(n)
    result = 'H'
    n.times { result = result.succ }

    result
  end

  def _is_character?(value)
    value.is_a?(String) && value.length == 1
  end

  def _chomsky_nf_vars(index, var, rule)
    rule_size   = rule.size
    current_var = index.zero? ? var : _find_letter(index - 1)
    letter      = _find_letter index
    rest        = rule[(index + 1)..rule_size].join

    [current_var, letter, rest]
  end

  def _add_var(holder, key, value)
    if holder.key? key
      holder[key] << [value]
    else
      holder[key] = [value]
    end
  end

  def _new_rules_buffer(rules, var)
    holder = {}

    rules.each do |rule|
      rule.each_with_index do |head, index|
        current_var, letter, rest =  _chomsky_nf_vars index, var, rule

        holder[rest] = letter unless holder.key? rest

        if index + 2 == rule.size
          _add_var holder, current_var, "#{head}#{rule[index + 1]}"

          break
        end

        _add_var holder, current_var, "#{head}#{holder[rest]}"
      end
    end

    holder
  end

  # chomksy_nf end

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
