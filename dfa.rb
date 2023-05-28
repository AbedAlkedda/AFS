# frozen_string_literal: true

require_relative 'automata'

# DFA class
class DFA < Automata
  attr_accessor :delta_star, :states, :finals, :start

  # ToDo
  # R1
  # R2

  def to_min
    finals = _finals
    states = _states
    r0     = _r0 finals, states
    steps  = {}

    steps['r0'] = r0

    finals_hash = _finals_hash finals, states

    0.upto(30) do |l|
      r = _r finals, states, steps["r#{l}"]
      steps["r#{l + 1}"] = r

      break if steps["r#{l - 1}"] == r && (l - 1).positive?
    end

    _print finals_hash, r0, finals, states
  end

  private

  def _finals
    @finals.map { |f| f.join('').to_i }
  end

  def _states
    ltr = 'p'
    _swap_for_demo
    states = @states.each_with_object({}) do |elt, memo|
      memo[elt] = ltr
      ltr       = ltr.succ
    end

    puts "\nQ=#{states}"

    states
  end

  def _r0(finals, states)
    r0 = []
    @states.each_with_index do |p, _|
      @states.each_with_index do |q, _|
        r0 << [states[p], states[q]] if finals.include?(p) == finals.include?(q)
      end
    end

    r0
  end

  def _finals_hash(finals, states)
    (finals & states.keys).each_with_object({}) { |elt, memo| memo[elt] = states[elt] }
  end

  def _r(finals, states, ri)
    r = []
    @states.each_with_index do |p, _|
      @states.each_with_index do |q, _|
        if finals.include?(p) == finals.include?(q)
          @delta_star.each_key do |c|
            ri_set = _ri_set states, c, p, q
            r << (ri_set & ri).flatten if (ri_set & ri).any?
          end
        end
      end
    end
    r.uniq!

    r
  end

  def _swap_for_demo
    r = @states[1]
    h = r
    @states[1] = @states[2]
    @states[2] = h
  end

  def _print(finals_hash, r0, finals, states)
    puts "F=#{finals_hash.inspect}"

    puts "R0=#{r0.inspect}"

    f_equivalent = finals.flat_map { |s| states.values_at(s) }
    q_without_f  = (@states - (@states & finals)).flat_map { |s| states.values_at(s) }
    puts "{F, Q\\F }={#{f_equivalent}}, {#{q_without_f}}"
  end

  def _ri_set(states, c, p, q)
    lft = states[(_image [p], @delta_star[c])[0]]
    rgt = states[(_image [q], @delta_star[c])[0]]

    [[lft, rgt]]
  end
end
