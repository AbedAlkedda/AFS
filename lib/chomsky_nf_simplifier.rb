# frozen_string_literal: true

# simplify chomsky normal form
class ChomskyNFSimplifier
  def run(new_rules, alphabet)
    vars_with_one_letter = _vars_with_one_letter new_rules, alphabet

    return new_rules if vars_with_one_letter.empty?

    extendible_rules = _find_extendible_rules new_rules, vars_with_one_letter.keys

    return new_rules if extendible_rules.empty?

    missing_rules = _missing_rules extendible_rules, vars_with_one_letter

    _add_missing_rules missing_rules, new_rules

    new_rules
  end

  # def run(new_rules, alphabet)
  #   vars_with_one_letter = _vars_with_one_letter new_rules, alphabet

  #   return new_rules if vars_with_one_letter.empty?

  #   rules = _find_extendible_rules new_rules, vars_with_one_letter

  #   return new_rules if rules.empty?

  #   missing_rules = _missing_rules rules, vars_with_one_letter

  #   _add_missing_rules missing_rules, new_rules

  #   new_rules
  # end

  private

  def _vars_with_one_letter(new_rules, alphabet)
    vars = {}

    new_rules.each do |key, values|
      # skip simple rules like (A, a), (B, b),...
      next if values.size == 1

      letters   = values.select { |val| _is_letter val, alphabet }.uniq
      vars[key] = letters
    end

    vars
  end

  def _is_letter(val, alphabet)
    val.size == 1 && alphabet.include?(val.downcase)
  end

  def _find_extendible_rules(new_rules, rules_keys)
    extendible = {}

    filterd_rules = new_rules.reject { |_, rules| rules.is_a?(String) }

    filterd_rules.each do |letter, rules|
      rules_keys.each do |rules_key|
        rules.each do |rule|
          next unless rule.include?(rules_key)

          extendible[letter] ||= []
          extendible[letter] << rule
        end
      end
    end

    extendible
  end

  def _missing_rules(rules, vars)
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
        _check_special_case nf, res, var_rule, vars
      end
    end

    res
  end

  def _combinations(original_string, replacement_char, match_char)
    combinations = []

    0.upto(1) do |i|
      0.upto(1) do |j|
        new_rule = original_string.dup
        new_rule[0] = replacement_char if i == 1 && original_string[0] == match_char
        new_rule[1] = replacement_char if j == 1 && original_string[1] == match_char
        combinations << new_rule
      end
    end

    combinations.uniq
  end

  def _add_missing_rules(missing_rules, new_rules)
    missing_rules.each do |key, val|
      new_rules[key] = val.flatten.uniq
    end
  end

  def _check_special_case(nf, res, var_rule, vars)
    vars.each do |match_char, combi|
      next unless nf == match_char * 2

      missing_rules = combi.map { |lft| combi.map { |rgt| "#{lft}#{rgt}" } }.flatten

      res[var_rule] << missing_rules
    end

    res
  end
end
