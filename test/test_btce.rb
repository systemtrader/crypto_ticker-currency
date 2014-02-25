require 'minitest_helper'

class TestBTCe < Minitest::Test
  def common_tests
    assert !@result.has_key?("error")
    %i[ high low avg vol vol_cur last
        buy sell updated server_time ].each do |sym|
      assert @result.has_key?(sym)
    end
    assert @result[:high] >= @result[:low]
  end

  # note: These shouldn't exist. We should *not* be testing the BTC-e API, only this module.
  def test_btce_btcusd
    @result = CryptoTicker::BTCe.btcusd.parsed_response
    common_tests
  end

  def test_btce_ltcbtc
    @result = CryptoTicker::BTCe.ltcbtc.parsed_response
    common_tests
  end

  def test_btce_ltcusd
    @result = CryptoTicker::BTCe.ltcusd.parsed_response
    common_tests
  end

  def test_btce_btcrur
    @result = CryptoTicker::BTCe.btcrur.parsed_response
    common_tests
  end

  def test_btce_btceur
    @result = CryptoTicker::BTCe.btceur.parsed_response
    common_tests
  end

  def test_btce_nmcbtc
    @result = CryptoTicker::BTCe.nmcbtc.parsed_response
    common_tests
  end

  def test_btce_nvcbtc
    @result = CryptoTicker::BTCe.nvcbtc.parsed_response
    common_tests
  end

  def test_btce_trcbtc
    @result = CryptoTicker::BTCe.trcbtc.parsed_response
    common_tests
  end

  def test_btce_ppcbtc
    @result = CryptoTicker::BTCe.ppcbtc.parsed_response
    common_tests
  end

  def test_btce_ftcbtc
    @result = CryptoTicker::BTCe.ftcbtc.parsed_response
    common_tests
  end

end

