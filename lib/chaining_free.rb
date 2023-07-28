# frozen_string_literal: true

# remove chaining rules from CFG
class ChainingFree
  def run(rules, vars)
    @rules = rules
    @vars  = vars
    c_r    = _chaining_relation

    # build transivity relation from _chaining_relation(K) as A
    # remove _chaining_relation from rules
    (_rebuild_rules - c_r) + c_r.map { |r| _transitivity_relation r }.reduce(:concat)
  end

  private

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
end
