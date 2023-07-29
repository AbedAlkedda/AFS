# frozen_string_literal: true

require_relative '../lib/falafel'

RSpec.describe 'Calculator integration' do
  it 'Generate Chomksy normal form' do
    alphabet  = %w[a b]
    vars_set  = %w[S X Y]
    start_var = 'S'
    rules     = { 'S' => [[], ['aSbS']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules
    cfg.epsilon_free
    cfg.chomksy_nf cfg.rules_ef
    result = cfg.chomksy_nf cfg.rules_ef
    res = { "A"=>"a", "B"=>"b", "S"=>["AH", "AJ", "AI", "AB"], "H"=>["SI"], "I"=>["BS", "BS"], "J"=>["SB"] }

    expect(result).to eq(res)
  end
end
