# frozen_string_literal: true

# used to clear a CFG from the epsilon rules
class EpsilonFree

  def run
  end

  private

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
end
