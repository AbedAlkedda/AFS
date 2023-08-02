# frozen_string_literal: true

# simplify chomsky normal form
class ChomskyNFSimplifier
  def run(new_rules, alphabet)
    var_has_one_letter = _var_has_one_letter new_rules, alphabet

    return new_rules if var_has_one_letter.empty?

    rules = _find_modify_rules new_rules, var_has_one_letter

    return new_rules if rules.empty?

    missing_rules = _generate_missing_rules rules, var_has_one_letter

    _add_missing_rules missing_rules, new_rules

    new_rules
  end

  private

  def _var_has_one_letter(new_rules, alphabet)
    vars = {}

    new_rules.each do |key, values|
      next if values.size == 1

      values.each do |val|
        next unless val.size == 1 && alphabet.include?(val.downcase)

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
