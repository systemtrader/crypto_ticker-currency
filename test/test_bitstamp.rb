require 'minitest_helper'

class TestBitstamp < Minitest::Test
  def test_bitstamp_btcusd
    @result = CryptoTicker::Bitstamp.btcusd.parsed_response
    %i[ last high low bid ask volume timestamp ].each do |sym|
      assert @result.has_key?(sym)
    end
    assert @result[:high] >= @result[:low]
    assert @result[:last] <= @result[:high]
    assert @result[:last] >= @result[:low]
  end
end

