# frozen_string_literal: true

require 'falafel'

pump = Falafel.new {}
lang   = ->(w) { w.match?(/\Aa*b*\z/) }
length = 3
pump_lemma = pump.pump_lemma lang, length

words = %w[aaaaa aaaab aaab aabb abb]

words.each do |word|
  pump_lemma.word = word
  pump_lemma.run show_pros: false
  r, s, t = pump_lemma.decomposition
  puts "is_regular? #{pump_lemma.is_regular}"
  puts "\"#{pump_lemma.word}\", decomposition { r = \"#{r}\" , s = \"#{s}\", t = \"#{t}\"}"
end
