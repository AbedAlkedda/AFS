require 'awesome_print'
require 'byebug'
require 'set'

# ToDo
# Print small solution
# change run to .to_dfa

# Bla
class NFA
  def initialize(delta_a, delta_b, state_set, finals)
    # Q, I, F, delta
    @delta_star = { 'a' => delta_a, 'b' => delta_b }
    @state_set  = state_set state_set
    @finals     = finals
  end

  # Relation Q X Q
  def relation(max)
    (1..max).flat_map { |x| (1..3).map { |y| [x, y] } }
  end

  # alle bilder eine menge m unter r
  def image(m, r)
    m.flat_map { |x| r.map { |y, z| z if x == y }.compact }.sort.uniq
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

  def run
    @state_set.each do |set|
      @delta_star.each do |delta, relation|
        res = image set, relation
        puts "#{set.inspect} · #{delta}(#{relation.inspect}) = #{res.inspect}"
      end
    end
  end

  def autotool_format
    @state_set.each do |set|
      @delta_star.each do |delta, relation|
        res = image set, relation
        puts "(#{set.to_a.join('')}, '#{delta}', #{res.to_a.join('')}),"
      end
    end
  end

  def clean_format
    @state_set.each do |set|
      @delta_star.each do |delta, relation|
        res = image set, relation
        puts "#{set.inspect}·#{delta}() = #{res.inspect}"
      end
      puts "\n"
    end
  end

  def finals_set
    filtered_set = @state_set.select { |subset| (subset.to_set & @finals.to_set).any? }

    puts "finals set = #{filtered_set.inspect}"
  end
end
