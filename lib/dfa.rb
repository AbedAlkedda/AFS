# frozen_string_literal: true

require_relative 'falafel'

# DFA class
class DFA < Falafel
  attr_accessor :delta_star, :states, :finals, :start

  def to_min
    finals = _finals
    states = _states
    r0     = _r0 finals, states
    steps  = {}

    steps['R0'] = r0
    finals_hash = _finals_hash finals, states
    steps       = _steps_builder finals, states, steps

    _print finals_hash, finals, states
    _print_steps steps
  end

  private

  def _finals
    @finals.map { |f| f.join('').to_i }
  end

  def _states
    ltr = 'p'
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

  def _r(finals, states, steps)
    r      = []
    last_r = steps["R#{steps.size - 1}"]

    last_r.each do |pair|
      @delta_star.each_key do |c|
        pair_frst = pair[0]
        pair_lst  = pair[1]

        ri_set = _ri_set states, c, states.key(pair_frst), states.key(pair_lst)

        break unless last_r.include? ri_set

        r << [pair_frst, pair_lst] unless r.include? [pair_frst, pair_lst]
      end
    end

    r
  end

  def _steps_builder(finals, states, steps)
    0.upto(1_000) do |l|
      r = _r finals, states, steps
      steps["R#{l + 1}"] = r

      return steps if steps["R#{l}"] == r
    end
  end

  def _print(finals_hash, finals, states)
    puts "F=#{finals_hash.inspect}"

    f_equivalent = finals.flat_map { |s| states.values_at(s) }
    q_without_f  = (@states - (@states & finals)).flat_map { |s| states.values_at(s) }
    puts "{F, Q\\F }={#{f_equivalent}}, {#{q_without_f}}"
  end

  def _print_steps(steps)
    steps.each { |k, v| puts "#{k}=#{v}" }
  end

  def _ri_set(states, c, p, q)
    lft = states[(_image [p], @delta_star[c])[0]]
    rgt = states[(_image [q], @delta_star[c])[0]]

    [lft, rgt]
  end
end
