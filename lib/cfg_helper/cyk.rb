# frozen_string_literal: true

module CFGHelper
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
      @is_in_l = _is_in_l?
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

          helper_var      = _helper_var i, j
          matrix_ele_info = _matrix_ele_info i, j
          @matrix[i][j]   = _add_to_matrix helper_var, matrix_ele_info
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

    def _matrix_ele_info(i, j)
      res = {}

      res['i'] = i
      res['j'] = j
      res['row_c'] = @matrix.count

      res
    end

    def _add_to_matrix(helper_var, matrix_ele_info)
      matrix_ele = '0'
      return if helper_var == matrix_ele

      keys = []

      @rules.each do |key, vals|
        vals.each do |val|
          keys << key if val == helper_var
        end
      end

      _matrix_ele keys, matrix_ele_info
    end

    def _matrix_ele(keys, matrix_ele_info)
      return 'S' if keys.include?('S') && _is_last_element?(matrix_ele_info)

      return keys.last if keys.size == 1

      keys.reject { |key| key == 'S' }.last || '0'
    end

    def _is_last_element?(matrix_ele_info)
      matrix_ele_info['i'].zero? && matrix_ele_info['j'] == matrix_ele_info['row_c'] - 1
    end

    def _is_in_l?
      @matrix.first.last == 'S'
    end
  end
end
