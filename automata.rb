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

  def to_dfa
    dfa = DFA.new { |a| a.build [], [], [], @start, [] }
    reachable     = []
    done_state    = []
    current_state = @start

    loop do
      @delta_star.each do |delta, relation|
        break if done_state.include? current_state

        res, rgt, lft = _new_state current_state, relation

        dfa.states << rgt unless dfa.states.include? rgt

        dfa.delta_star[delta] << [lft, rgt]

        reachable << res unless reachable.include? res

        reachable.delete res if done_state.include? res
      end

      break if reachable.empty?

      done_state << current_state unless done_state.include? current_state

      dfa.finals << current_state if (current_state & @finals).any?

      current_state = reachable.last

      reachable.pop
    end

    dfa
  end

  private

  # alle bilder eine menge m unter r
  def _image(m, r)
    m.flat_map { |x| r.map { |y, z| z if x == y }.compact }.sort.uniq
  end

  def _concat(set)
    set.to_a.join('').to_i
  end

  def _new_state(state, relation)
    res = _image state, relation
    rgt = _concat res
    lft = _concat state

    [res, rgt, lft]
  end
end
