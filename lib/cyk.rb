# frozen_string_literal: true

# Implemention of cyk algo.
class CYK
  def initialize(word)
    @word = word
  end

  def run
    _cyk_fill_diagonal
    _cyk

    @matrix
  end

  private

  def _cyk_fill_diagonal
    wrd_lng = @word.length
    @matrix = wrd_lng.times.map { wrd_lng.times.map { [] } }

    (0..wrd_lng - 1).each do |index|
      @matrix[index][index] = @word[index].upcase
    end
  end

  def _cyk
    @matrix.size.times do |limiter|
      (0...@matrix.length - limiter).each do |i|
        j = i + limiter
        next if i == j

        # puts "j:#{j}, i:#{i}, limiter: #{limiter}"
        # p_, q_ = _cyk_p_q i, j

        # rule = "#{p_}#{q_}"

        # @matrix[i][j] = _cyk_new_matrix_val rule
      end
    end
  end

  # def _cyk_p_q(i, j)
  #   h_   = j - 1
  #   h_  -= 1 until @chomsky_nf['hlp_hash'].values.include? @cyk_matrix[i][h_]
  #   p_   = @cyk_matrix[i][h_]
  #   q_   = @cyk_matrix[h_ + 1][j]

  #   [p_, q_]
  # end

  # def _cyk_new_matrix_val(rule)
  #   val = @chomsky_nf['rules'].select { |hash| hash.value?(rule) }&.first&.key(rule)
  #   val ||= '∅ '

  #   val
  # end
end
