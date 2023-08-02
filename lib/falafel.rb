# frozen_string_literal: true

require_relative 'rx'

# NFA to DFA
# DFA to REG
# Minimize DFA
# Remove epsilons from CFG
# Remove chaining from CFG
# Find a chomsky normal form fro CFG
# Apply CYK alogrithm on CFG and solve word problem
class Falafel
  def self.new
    instance = allocate
    yield instance

    instance
  end

  def build(*args, states:, starts:, finals:)
    d_a, d_b    = args
    @delta_star = { a: d_a, b: d_b }
    @state_set  = power_set states
    @finals     = finals
    @states     = states
    @start      = starts
  end

  # Binary relation for max number
  def relation(max)
    (1..max).flat_map { |x| (1..3).map { |y| [x, y] } }
  end

  # Concatenation two states
  # Example: [[1, 2]] . [[2, 1]] => [1, 1]
  def compose(lft, rgt)
    lft.flat_map { |x, y1| rgt.select { |y2, _| y1 == y2 }.map { |_, z| [x, z] } }
  end

  # Power set of Q
  def power_set(states)
    power_set = [[]]
    states.each { |e| power_set.concat(power_set.map { |set| set + [e] }) }

    power_set
  end

  def potens_set
    @state_set.each { |set| @delta_star.each { |delta, relation| puts "#{set.inspect}·#{delta}() = #{_image(set, relation).inspect}" } }
  end

  def nfa_to_dfa
    require_relative 'dfa'

    dfa = DFA.new { |a| a.build [], [], states: [], starts: @start, finals: [] }
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
    dfa.finals.uniq!

    _print_dfa dfa

    dfa
  end

  def nfa_to_reg
    RX.new { |rx| rx.build @states, @delta_star, @start, @finals }
  end

  def dfa_to_min(automat)
    d_a    = automat.delta_star[:a]
    d_b    = automat.delta_star[:b]
    states = automat.states
    starts = automat.start
    finals = automat.finals

    dfa = DFA.new { |a| a.build d_a, d_b, states: states, starts: starts, finals: finals }
    dfa.to_min
  end

  def pump_lemma
    require_relative 'pump'

    Pump.new lang: nil, word: nil, n: 2, k: 20
  end

  def cfg(alphabet, vars_set, start_var, rules)
    require_relative 'cfg'

    CFG.new alphabet, vars_set, start_var, rules
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

  def _print_dfa(dfa)
    puts "dfa:\nfinals: #{dfa.finals.map { |ele| _concat(ele).to_i }}"
    puts "states: #{dfa.states.map(&:to_i)}"
    dfa.delta_star.each { |k, v| v.each { |e| puts "(#{e[0]} ,'#{k}', #{e[1]})" } }
  end
end
