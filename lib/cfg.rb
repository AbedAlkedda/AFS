# frozen_string_literal: true

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

    # Cyk
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
    @rules    = @rules_ef || @rules_cf

    # add cases like (A, a), (B, b)
    _add_single_vars new_rules

    # change rules like (X, aX) to (X, AX)
    _handle_simple_rule new_rules

    @chomksy_nf_rules = _handle_all_rule new_rules
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
        new_rules[r.upcase] = r
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

  def _is_character?(value)
    value.is_a?(String) && value.length == 1
  end

  def _new_rules_buffer(rules, var)
    helper_vars = _helper_vars rules
    helper_vars.merge! @alphabet.each_with_object({}) { |ele, meme| meme[ele.capitalize] = ele.capitalize }

    _new_rules rules, var, helper_vars
  end

  def _new_rules(rules, var, helper_vars)
    holder = {}

    rules.each do |rule|
      rest = ''
      rule.each_with_index do |head, index|
        current_var = index.zero? ? var : rest

        holder[current_var] ||= []

        rest = _chomsky_nf_vars index, rule, helper_vars

        nf_rest = "#{head}#{rest}"

        if index + 2 == rule.size
          if rest.nil?
            rest     = rule.last
            nf_rest += rest
          end

          holder[current_var] << nf_rest

          break
        else
          holder[current_var] << nf_rest
        end
      end
    end

    holder
  end

  def _chomsky_nf_vars(index, rule, helper_vars)
    rule_size = rule.size
    rest      = rule[(index + 1)..rule_size].join

    helper_vars.key(rest)
  end

  def _helper_vars(rules)
    helper_vars = {}

    rules.each do |rule|
      rule.each_with_index do |_, index|
        letter, rest = _chomsky_nf_helper_vars index, rule, helper_vars.keys

        break if index + 2 == rule.size

        next if helper_vars.values.include? rest

        helper_vars[letter] = rest unless helper_vars.key?(letter) && rest.size > 1
      end
    end

    helper_vars
  end

  def _chomsky_nf_helper_vars(index, rule, helper_vars)
    rule_size   = rule.size
    letter      = helper_vars.empty? ? _find_letter(index) : helper_vars.sort!.last.succ
    rest        = rule[(index + 1)..rule_size].join

    [letter, rest]
  end

  def _find_letter(n)
    result = 'H'
    n.times { result = result.succ }

    result
  end

  def _add_var(holder, key, value)
    if holder.key? key
      holder[key] << [value]
    else
      holder[key] = [value]
    end
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
