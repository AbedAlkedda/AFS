# frozen_string_literal: true

# Implemention of cyk algo.
class CYK
  attr_reader :matrix, :is_in_l

  def initialize(word, custom_rule)
    @word        = word
    @rules       = custom_rule.select { |_, val| val.is_a?(Array) }
    @helper_vars = @rules.values.flatten
  end

  def run
    _cyk_fill_diagonal
    _cyk_fill_matrix
    _is_in_l?
  end

  private

  def _cyk_fill_diagonal
    wrd_lng = @word.length
    @matrix = wrd_lng.times.map { wrd_lng.times.map { [] } }

    (0..wrd_lng - 1).each do |index|
      @matrix[index][index] = @word[index].upcase
    end
  end

  def _cyk_fill_matrix
    @matrix.size.times do |limiter|
      (0...@matrix.length - limiter).each do |i|
        j = i + limiter

        next if i == j

        helper_var = _helper_var i, j

        @matrix[i][j] = _add_to_matrix helper_var
      end
    end
  end

  def _helper_var(row, col)
    res = '0'

    (row..col - 1).step(1) do |h|
      p_  = @matrix[row][h]
      q_  = @matrix[h + 1][col]
      res = "#{p_}#{q_}"

      break if @helper_vars.include? res
    end

    res
  end

  def _add_to_matrix(rule)
    res = '0'
    return if rule == res

    @rules.each do |key, vals|
      vals.each do |val|
        res = key if val == rule
      end
    end

    res
  end

  def _is_in_l?
    @is_in_l = @matrix.first.last == 'S'
  end
end
