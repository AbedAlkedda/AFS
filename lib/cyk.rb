# frozen_string_literal: true

# Implemention of cyk algo.
class CYK
  def initialize(word)
    @word = word
  end

  def run
    _cyk_fill_diagonal
  end

  private

  def _cyk_fill_diagonal
    wrd_lng = @word.length
    table   = Array.new(wrd_lng) { Array.new(wrd_lng) { [] } }

    (0..wrd_lng - 1).each do |index|
      table[index][index] = @word[index].upcase
    end

    table
  end
end
