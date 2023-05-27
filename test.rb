require 'byebug'

def shuffle(u, v)
  return [v] if u.empty?
  return [u] if v.empty?

  result = []

  shuffle(u[1..], v).each { |w| result << u[0] + w }

  shuffle(u, v[1..]).each { |w| result << v[0] + w }

  result
end

# Example usage:
u = 'foo'
v = 'bar'

shuffled_words = shuffle(u, v)
puts shuffled_words.inspect
