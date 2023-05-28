require 'byebug'

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

def pumping_lemma(lang, word, n, k)
  r = ''
  s = ''
  t = ''

  (0...word.length - n + 1).each do |i|
    r = word[0...i]
    s = word[i...i + n]
    t = word[i + n..]

    break if s.length.positive? && (r + s * k + t) != word && lang.call(r + s * k + t)
  end
  [r, s, t]
end

# a^* b^*
lang1 = ->(w) { w.match?(/\Aa*b*\z/) }
word_lang1 = 'aaabbb'

u, v, w = pumping_lemma(lang1, word_lang1, 2, 20)
puts "( \"#{word_lang1}\", Zerlegung { u = \"#{u}\" , v = \"#{v}\", w = \"#{w}\"} )"

# { a^i b^j | i /= j }
lang2 = ->(w) { w.count('a') != w.count('b') }
word_lang2 = %w[aaaaaabb aaaaaabbbb aaaaabbb aaabbbb aaabbbbb aabbbb]

puts "\nTask 2\n"
word_lang2.each do |word|
  u, v, w = pumping_lemma(lang2, word, 2, 20)
  puts ",( \"#{word}\", Zerlegung { u = \"#{u}\" , v = \"#{v}\", w = \"#{w}\"} )"
end
