require 'minitest_helper'

class TestMtGox < Minitest::Test
  def test_mtgox_btcusd
    @result = CryptoTicker::MtGox.btcusd.parsed_response
    %i[ high low avg vol vwap last last_local 
        last_orig last_all buy sell now item ].each do |sym|
      assert @result.has_key?(sym)
    end
    assert @result[:high] >= @result[:low]
  end
end

