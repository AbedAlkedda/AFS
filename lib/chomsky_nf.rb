# frozen_string_literal: true

require_relative 'chomsky_nf_simplifier'

# convert to Chomsky Normal Form
class ChomskyNF
  def run(rules, alphabet)
    new_rules = {}
    @rules    = rules
    @alphabet = alphabet

    # add cases like (A, a), (B, b)
    _add_single_vars new_rules

    # change rules like (X, aX) to (X, AX)
    _handle_simple_rule new_rules

    _handle_all_rule new_rules
    simplifier = ChomskyNFSimplifier.new
    puts simplifier.run
    _simplify new_rules
  end

  private

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

  def _check_simplify(rule, holder, current_var)
    return false unless rule.size == 1

    holder[current_var] << rule.last unless holder[current_var].include? rule

    true
  end

  def _new_rules(rules, var, helper_vars)
    holder = {}

    rules.each do |rule|
      rest = ''
      rule.each_with_index do |head, index|
        current_var = index.zero? ? var : rest
        holder[current_var] ||= []

        is_simple = _check_simplify rule, holder, current_var

        break if is_simple

        rest = _chomsky_nf_vars index, rule, helper_vars

        nf_rest = "#{head}#{rest}"

        if index + 2 == rule.size
          if rest.nil?
            rest     = rule.last
            nf_rest += rest
          end

          holder[current_var] << nf_rest unless holder[current_var].include? nf_rest

          break
        else
          holder[current_var] << nf_rest unless holder[current_var].include? nf_rest
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

  def _simplify(new_rules)
    var_has_one_letter = _var_has_one_letter new_rules

    return new_rules if var_has_one_letter.empty?

    rules = _find_modify_rules new_rules, var_has_one_letter

    return new_rules if rules.empty?

    missing_rules = _generate_missing_rules rules, var_has_one_letter

    _add_missing_rules missing_rules, new_rules

    new_rules
  end

  def _var_has_one_letter(new_rules)
    vars = {}

    new_rules.each do |key, values|
      next if values.size == 1

      values.each do |val|
        next unless val.size == 1 && @alphabet.include?(val.downcase)

        vars[key] ||= []
        vars[key] << val
      end
    end

    vars
  end

  def _find_modify_rules(new_rules, vars)
    modify = {}

    new_rules.each do |key, val|
      next if val.is_a?(String)

      val.each do |v|
        vars.each_key do |k|
          next unless v.include?(k)

          res = val.select { |x| x.include? k }

          modify[key] ||= []
          modify[key] << res
        end
      end
    end

    modify
  end

  def _generate_missing_rules(rules, vars)
    res = {}

    rules.each do |var_rule, nfs|
      nfs.flatten.each do |nf|
        vars.each do |match_char, replacement_chars|
          replacement_chars.each do |rc|
            new_rules = _combinations nf, rc, match_char
            res[var_rule] ||= []
            res[var_rule] << new_rules
          end
        end
      end
    end

    res
  end

  def _combinations(original_string, replacement_char, match_char)
    combinations = []

    0.upto(1) do |i|
      0.upto(1) do |j|
        new_string = original_string.dup
        new_string[0] = replacement_char if i == 1 && original_string[0] == match_char
        new_string[1] = replacement_char if j == 1 && original_string[1] == match_char
        combinations << new_string
      end
    end

    combinations.uniq
  end

  def _add_missing_rules(missing_rules, new_rules)
    missing_rules.each { |key, val| new_rules[key] = val.flatten.uniq! }
  end
end
