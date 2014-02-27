require 'minitest_helper'

class TestCryptoTicker < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CryptoTicker::VERSION
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

    klass = CryptoTicker::get_class_for('localbitcoins')
    assert_equal CryptoTicker::Localbitcoins, klass

    klass = CryptoTicker::get_class_for('Localbitcoins')
    assert_equal CryptoTicker::Localbitcoins, klass

    # not yet implemented
    #
    #klass = CryptoTicker::get_class_for('Vircurex')
    #assert_equal CryptoTicker::Vircurex, klass

    #klass = CryptoTicker::get_class_for('vircurex')
    #assert_equal CryptoTicker::Vircurex, klass
  end

end


