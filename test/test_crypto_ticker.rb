require 'minitest_helper'

class TestCryptoTicker < Minitest::Test
  def common_tests
    assert !@result.has_key?("error")
    %i[ high low avg vol vol_cur last 
        buy sell updated server_time ].each do |sym|
      assert @result.has_key?(sym)
    end
    assert @result[:high] >= @result[:low]
  end

  def test_that_it_has_a_version_number
    refute_nil ::CryptoTicker::VERSION
  end

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

  def test_get_class_for
    klass = CryptoTicker::get_class_for('BTC-e')
    assert_equal CryptoTicker::BTCe, klass

    klass = CryptoTicker::get_class_for('BTCe')
    assert_equal CryptoTicker::BTCe, klass

    klass = CryptoTicker::get_class_for('btc-e')
    assert_equal CryptoTicker::BTCe, klass

    klass = CryptoTicker::get_class_for('Bitstamp')
    assert_equal CryptoTicker::Bitstamp, klass

    klass = CryptoTicker::get_class_for('bitstamp')
    assert_equal CryptoTicker::Bitstamp, klass

    # not yet implemented
    #
    #klass = CryptoTicker::get_class_for('Vircurex')
    #assert_equal CryptoTicker::Vircurex, klass

    #klass = CryptoTicker::get_class_for('vircurex')
    #assert_equal CryptoTicker::Vircurex, klass
  end

end


