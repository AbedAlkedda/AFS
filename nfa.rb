# frozen_string_literal: true

require_relative 'dfa'
require_relative 'automata'
# NFA class
class NFA < Automata
  def to_dfa
    reachable     = []
    done_state    = []
    dfa           = DFA.new { |a| a.build [], [], [], @start, [] }
    current_state = @start

    loop do
      @delta_star.each do |delta, relation|
        break if done_state.include? current_state

        res = _image current_state, relation
        rgt = _concat res
        lft = _concat current_state

        dfa.states << rgt unless dfa.states.include? rgt
        dfa.states << lft unless dfa.states.include? lft

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
    puts "states: #{dfa.states.map(&:to_i)}"
    dfa.delta_star.each { |k, v| v.each { |e| puts "(#{e[0]} ,#{k}, #{e[1]})" } }
  end

  def potens_set
    @state_set.each { |set| @delta_star.each { |delta, relation| puts "#{set.inspect}·#{delta}() = #{_image(set, relation).inspect}" } }
  end

  def to_reg
    l0 = _l0
    steps = {}
    steps['l0'] = l0

    2.times do |h|
      l = []
      @states.each_with_index do |_, p|
        l[p] = []
        @states.each_with_index do |_, q|
          l[p][q] = _l steps["l#{h}"], p, q, steps.size - 1
        end
      end
      steps["l#{steps.size}"] = l
      puts 'done'
    end

    steps.each { |k, v| puts k; v.each { |s| puts s.inspect } }
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

  def _l(lll, p, q, h)
    case [h == p, h == q]
    when [true, true]  then _states_equal lll, h
    when [false, true] then _states_begin lll, h, p
    when [true, false] then _states_end   lll, h, q
    else _states_unequal lll, p, q, h
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
    "(#{_state_simplify l, h})*"
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
