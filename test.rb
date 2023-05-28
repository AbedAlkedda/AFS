# require 'byebug'

# def shuffle(u, v)
#   return [v] if u.empty?
#   return [u] if v.empty?

#   result = []

#   shuffle(u[1..], v).each { |w| result << u[0] + w }

#   shuffle(u, v[1..]).each { |w| result << v[0] + w }

#   result
# end

# # Usage example :
# u = 'foo'
# v = 'bar'

# shuffled_words = shuffle(u, v)
# puts shuffled_words.inspect

def pumping_lemma(language, word, n)
  r = ''
  s = ''
  t = ''

  (0...word.length - n + 1).each do |i|
    r = word[0...i]
    s = word[i...i + n]
    t = word[i + n..]

    break if s.length.positive? && (r + s * 2 + t) != word && language.call(r + s * 2 + t)
  end

  # Return the values for r, s, and t
  [r, s, t]
end

language = ->(w) { w.count('b').even? }
language_2 = ->(w) { w.count('b') == w.count('a') }

# a^* b^*
# language = ->(w) { w.match?(/\Aa*b*\z/) }

# { a^i b^j | i /= j }
# language = ->(w) { w.count('a') != w.count('b') }

word = 'aaaaabbbbb'

n = 2

u, v, w = pumping_lemma(language_2, word, n)

puts "( \"#{word}\", Zerlegung { u = \"#{u}\" , v = \"#{v}\", w = \"#{w}}\" )"
