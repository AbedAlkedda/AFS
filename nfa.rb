# frozen_string_literal: true

require_relative 'dfa'

# NFA class
class NFA
  def initialize(delta_a, delta_b, state_set, start, finals)
    # Q, I, F, delta
    @delta_star = { a: delta_a, b: delta_b }
    @state_set  = state_set state_set
    @finals     = finals
    @states     = state_set
    @start      = start
    @empty      = "\u2205"
  end

  # Relation Q X Q
  def relation(max)
    (1..max).flat_map { |x| (1..3).map { |y| [x, y] } }
  end

  # Verkettung
  def compose(a, b)
    a.flat_map { |x, y1| b.select { |y2, _| y1 == y2 }.map { |_, z| [x, z] } }
  end

  # Potenzmenge von Q
  def state_set(q)
    power_set = [[]]
    q.each { |e| power_set.concat(power_set.map { |set| set + [e] }) }

    power_set
  end

  def to_dfa
    reachable     = []
    done_state    = []
    dfa           = DFA.new [], [], [], @start, []
    current_state = @start

    loop do
      @delta_star.each do |delta, relation|
        break if done_state.include? current_state

        res = _image current_state, relation
        rgt = _concat res
        lft = _concat current_state

        dfa.state_set << rgt unless dfa.state_set.include? rgt
        dfa.state_set << lft unless dfa.state_set.include? lft

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

    puts "finals: #{dfa.finals.map { |ele| _concat(ele).to_i }}"
    puts "states: #{dfa.state_set.map(&:to_i)}"
    dfa.delta_star.each { |k, v| v.each { |e| puts "(#{e[0]} ,#{k}, #{e[1]})" } }
  end

  def potens_set
    @state_set.each { |set| @delta_star.each { |delta, relation| puts "#{set.inspect}·#{delta}() = #{_image(set, relation).inspect}" } }
  end

  def to_reg
    steps = {}
    l0 = _l0
    steps['l0'] = l0

    puts 'L0'
    l0.each { |row| puts row.inspect }

    l_next = []

    @states.each_with_index do |_, p|
      l_next[p] = []
      @states.each_with_index do |_, q|
        l_next[p][q] = _l l0, p, q
      end
    end
    steps["l#{steps.size}"] = l_next

    puts 'l1'
    l_next.each { |row| puts row.inspect }
  end

  private

  # alle bilder eine menge m unter r
  def _image(m, r)
    m.flat_map { |x| r.map { |y, z| z if x == y }.compact }.sort.uniq
  end

  def _concat(set)
    set.to_a.join('').to_i
  end

  def _l0
    l0 = []
    @states.each_with_index do |_, i|
      l0[i] = []
      @states.each_with_index do |_, y|
        l0[i][y] = _letter i, y
      end
    end

    l0
  end

  def _l(l0, p, q)
    h = 0
    case [h == p, h == q]
    when [true, true]  then _states_equal l0, h
    when [false, true] then _states_begin l0, h, p
    when [true, false] then _states_end   l0, h, q
    else _states_unequal l0, p, q, h
    end
  end

  def _letter_build(l, i, y)
    letter  = i == y ? 'ε' : ''
    letter += letter.empty? ? l : "+#{l}"

    letter
  end

  def _reachable(delta, i, y)
    (@delta_star[delta] & [[i + 1, y + 1]]).any?
  end

  def _letter(i, y)
    letter = ''

    if _reachable :a, i, y
      letter = _letter_build 'a', i, y
    elsif _reachable :b, i, y
      letter = _letter_build 'b', i, y
    else
      letter += '∅'
      letter  = 'ε' if i == y
    end

    letter
  end

  def _states_equal(l, h)
    letter_holder = _state_simplify l, h

    "(#{letter_holder})*"
  end

  def _states_begin(l, h, p)
    lft    = l[p][h]
    rgt    = l[h][h].size == 3 ? l[h][h][2] : l[h][h]
    letter = "#{lft}.(#{rgt})*"
    letter = @empty if lft == @empty || rgt == @empty

    letter
  end

  def _states_end(l, h, q)
    lft    = l[h][h]
    rgt    = l[h][q]
    letter = "(#{lft})*.#{rgt}"
    letter = @empty if lft == @empty || rgt == @empty

    letter
  end

  def _states_unequal(l0, p, q, h)
    lft    = l0[p][q]
    letter = _state_simplify l0, h
    rgt    = "#{l0[p][h]}.(#{letter})* .#{l0[h][q]}"
    rgt    = @empty if l0[p][h] == @empty || l0[h][h] == @empty || l0[h][q] == @empty

    rgt == @empty ? lft : "#{lft} + (#{rgt})"
  end

  def _state_simplify(l, h)
    l[h][h].size == 3 ? l[h][h][2] : l[h][h]
  end
end
