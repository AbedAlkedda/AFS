class CFG
  attr_accessor :terminals, :variables, :start_symbol, :productions

  def initialize(terminals, variables, start_symbol)
    @terminals = terminals
    @variables = variables
    @start_symbol = start_symbol
    @productions = {}
  end

  def add_production(lhs, rhs)
    @productions[lhs] ||= []
    @productions[lhs] << rhs
  end

  def generate_random
    expand(@start_symbol)
  end

  private

  def expand(symbol)
    production = @productions[symbol]
    if production.nil?
      return symbol
    else
      rhs = production.sample
      rhs.map { |s| expand(s) }.join
    end
  end
end
