# frozen_string_literal: true

# Practice some stuff out Theorithsche Informatik
class Automata
  def self.new
    instance = allocate
    yield instance

    instance
  end

  def build(d_a, d_b, states, starts, finals)
    @delta_star = { a: d_a, b: d_b }
    @state_set  = power_set states
    @finals     = finals
    @states     = states
    @start      = starts
    @empty      = "\u2205"
  end

  # Binary relation for max number
  def relation(max)
    (1..max).flat_map { |x| (1..3).map { |y| [x, y] } }
  end

  # Concatenation two states [[1,2]] . [[2, 1]] => [1, 1]
  def compose(lft, rgt)
    lft.flat_map { |x, y1| rgt.select { |y2, _| y1 == y2 }.map { |_, z| [x, z] } }
  end

  # Power set of Q
  def power_set(states) 
    power_set = [[]]
    states.each { |e| power_set.concat(power_set.map { |set| set + [e] }) }

    power_set
  end
end
