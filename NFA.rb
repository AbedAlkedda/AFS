# frozen_string_literal: true

# NFA class
class NFA
  def initialize(delta_a, delta_b, state_set, start, finals)
    # Q, I, F, delta
    @delta_star = { a: delta_a, b: delta_b }
    @state_set  = state_set state_set
    @finals     = finals
    @start      = start
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
    finales       = []
    states        = []
    current_state = @start

    loop do
      @delta_star.each do |delta, relation|
        break if done_state.include? current_state

        res = _image current_state, relation
        rgt = _concat(res).empty?           ? '0' : _concat(res)
        lft = _concat(current_state).empty? ? '0' : _concat(current_state)

        states << rgt unless states.include? rgt

        puts "(#{lft}, '#{delta}', #{rgt})"

        reachable << res unless reachable.include? res

        reachable.pop if done_state.include? res
      end

      break if reachable.empty?

      done_state << current_state unless done_state.include? current_state
      finales    << current_state if (current_state & @finals).any?

      current_state = reachable.last

      reachable.pop
    end

    puts "finles: #{finales.map { |ele| _concat(ele).to_i }}"
    puts "states: #{states.map(&:to_i)}"
  end

  def potens_set
    @state_set.each { |set|  @delta_star.each { |delta, relation| puts "#{set.inspect}·#{delta}() = #{_image(set, relation).inspect}" } }
  end

  private

  # alle bilder eine menge m unter r
  def _image(m, r)
    m.flat_map { |x| r.map { |y, z| z if x == y }.compact }.sort.uniq
  end

  def _concat(set)
    set.to_a.join('')
  end
end
