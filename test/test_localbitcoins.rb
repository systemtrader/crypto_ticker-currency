require 'minitest_helper'

class TestLocalbitcoins < Minitest::Test
  def test_localbitcoins_btcusd
    result = CryptoTicker::Localbitcoins.btcusd.parsed_response
    %i[ last volume ].each do |sym|
      assert result.has_key?(sym)
    end
    assert !result[:last].nil?
  end
end

