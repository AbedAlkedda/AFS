# frozen_string_literal: true

# used to clear a CFG from the epsilon rules
class EpsilonFree
  def run(rules)
    epsilon  = _epsilon rules
    rules_ef = {}

    return if epsilon.empty?

    epsilon.each do |e_class|
      cleared_rules     = _cleared_rules rules[e_class]
      epsilon_free_word = cleared_rules.map(&:join)
      grammer           = _grammer_epsilon_free epsilon_free_word, e_class
      rules_ef[e_class] = grammer
    end

    rules_ef
  end

  def rebuild_rules(current_rules, rules_epsilon_free)
    missing_vars = current_rules.keys - rules_epsilon_free.keys

    res = {}
    rules_epsilon_free.each do |key, rules|
      res[key] = []
      rules.each do |rule|
        res[key] << rule.chars
      end
    end

    missing_vars.each { |v| res[v] = current_rules[v] }

    res
  end

  private

  def _epsilon(rules)
    res = rules.map do |var, rule|
      next unless rule.include? []

      var
    end
    res.reject(&:nil?)
  end

  def _cleared_rules(rules)
    rules.reject(&:empty?)
  end

  def _grammer_epsilon_free(epsilon_free_word, e_class)
    rules_epsilon_location = _new_rules_epsilon_location epsilon_free_word, e_class

    res = []
    rules_epsilon_location.map do |rule, possibilities|
      possibilities.each do |possibility|
        res << _remove_e_class(possibility, rule.split(''))
      end

      res << epsilon_free_word.delete(e_class) if possibilities.size == 1
    end

    res
  end

  def _new_rules_epsilon_location(s_rule, e_class)
    res = {}
    s_rule.each do |rule|
      s_index = []
      rule.each_char.with_index { |char, index| s_index << index if char == e_class }
      res[rule] = _power_set(s_index)
    end

    res
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

  def _remove_e_class(possibility, cleared_rules)
    return cleared_rules.join '' if possibility.empty?

    new_rule = cleared_rules.join ''
    possibility.reverse.each { |index| new_rule.slice! index }

    new_rule
  end
end
