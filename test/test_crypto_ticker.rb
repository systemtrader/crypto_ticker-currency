require 'minitest_helper'
require 'uri'

class TestCryptoTicker < MiniTest::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::CryptoTicker::VERSION
  end

  def test_urls
    # BTC-e
    # BTC/USD
    assert CryptoTicker::BTCe.ticker('BTC/USD')   =~ URI::regexp
    assert CryptoTicker::BTCe.ticker('BTC','USD') =~ URI::regexp
    assert CryptoTicker::BTCe.ticker('btc','usd') =~ URI::regexp
    assert CryptoTicker::BTCe.ticker('bTC','UsD') =~ URI::regexp

    # LTC/USD
    assert CryptoTicker::BTCe.ticker('ltc', 'usd') =~ URI::regexp

    # LTC/BTC
    assert CryptoTicker::BTCe.ticker('ltc', 'btc') =~ URI::regexp

    # other
    assert CryptoTicker::BTCe.ticker('NMC/BTC') =~ URI::regexp
    assert CryptoTicker::BTCe.ticker('NVC/BTC') =~ URI::regexp
    assert CryptoTicker::BTCe.ticker('PPC/BTC') =~ URI::regexp
    assert CryptoTicker::BTCe.ticker('RUC/BTC') =~ URI::regexp

    # invalid
    assert_nil CryptoTicker::BTCe.ticker('USD/BTC')
    assert_nil CryptoTicker::BTCe.ticker('usd', 'btc')

    # invalid - order is important
    assert_nil CryptoTicker::BTCe.ticker('btc', 'ltc')

    # invalid
    assert_nil CryptoTicker::BTCe.ticker('xyz', 'abc')

    # trades
    assert CryptoTicker::BTCe.trades('BTC/USD') =~ URI::regexp

    # depth
    assert CryptoTicker::BTCe.depth('BTC/USD') =~ URI::regexp

    # MtGox
    assert CryptoTicker::MtGox.ticker('BTC/USD') =~ URI::regexp
    assert CryptoTicker::MtGox.trades('BTC/USD') =~ URI::regexp
    assert CryptoTicker::MtGox.depth('BTC/USD')  =~ URI::regexp

    # Vircurex
    assert CryptoTicker::Vircurex.ticker =~ URI::regexp

    # Bitstamp
    assert CryptoTicker::Bitstamp.ticker =~ URI::regexp
  end

end

