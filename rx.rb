# frozen_string_literal: true

# Regex string builder
class RX
  def self.new
    instance = allocate
    yield instance

    instance
  end
end