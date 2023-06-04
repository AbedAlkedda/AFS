# frozen_string_literal: true

# Regex string builder
class RX
  def self.new
    instance = allocate
    yield instance

    instance
  end

  def build(states, delta_star)
    @states     = states
    @delta_star = delta_star
    @epsilon    = "\u2205"
    _to_reg
  end

  private

  def _to_reg
    l0 = _l0
    steps = {}
    steps['l0'] = l0

    @states.size.times do |h|
      l = []
      @states.each_with_index do |_, p|
        l[p] = []
        @states.each_with_index do |_, q|
          l[p][q] = _l steps["l#{h}"], p, q, steps.size - 1
        end
      end
      steps["l#{steps.size}"] = l
    end
    _print_matrix steps
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

  def _l(l, p, q, h)
    case [h == p, h == q]
    in [true, true]  then _states_equal l, h
    in [true, false] then _states_begin  l, h, q
    in [false, true] then _states_end l, h, p
    else _states_unequal l, p, q, h
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

  def _states_begin(l, h, q)
    lft    = l[h][q]
    rgt    = _clear_reg l[h][h]
    letter = "#{lft}.(#{rgt})*"
    letter = @epsilon if lft == @epsilon || rgt == @epsilon

    letter
  end

  def _states_end(l, h, p)
    lft    = _clear_reg l[h][h]
    rgt    = l[h][p]
    letter = "(#{lft})*.#{rgt}"
    letter = @epsilon if lft == @epsilon || rgt == @epsilon

    letter
  end

  def _states_unequal(l0, p, q, h)
    lft = l0[p][q]
    lft = lft.dup
    lft.gsub!(/∅/, '')

    rgt = _states_unequal_rgt l0, p, q, h
    rgt = rgt.dup
    rgt.gsub!(/∅./, '')

    return "(#{rgt})" if lft.empty?

    rgt == @epsilon ? lft : "#{lft}+(#{rgt})"
  end

  def _state_simplify(l, h)
    l[h][h].size == 3 ? l[h][h][2] : l[h][h]
  end

  def _clear_reg(str)
    str.gsub(/ε./, '')
  end

  def _empty?(state)
    state == @epsilon
  end

  def _states_unequal_rgt(l, p, q, h)
    letter = _clear_reg l[h][h]
    rgt    = "#{l[h][q]}.(#{letter})*.#{l[p][h]}"
    rgt    = @epsilon if _empty?(l[p][h]) || _empty?(l[h][h]) || _empty?(l[h][q])

    rgt
  end

  def _print_matrix(steps)
    steps.each do |key, value|
      puts key
      max_width = value.map { |column| column.max_by(&:length).length }.max
      value.transpose.each do |column|
        column.each do |element|
          printf("\t|%-#{max_width}s", element)
        end
        puts '|'
      end
    end
  end
end
