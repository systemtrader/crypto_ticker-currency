require 'minitest_helper'
require 'uri'
require 'json'
require 'pp'

class TestCryptoTicker < Minitest::Test
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

  def test_btce_parser
    data = '{"ticker":{"high":99,"low":81,"avg":90,"vol":1857509.30091,"vol_cur":20229.18878,"last":84.5,"buy":84.873,"sell":84.01,"server_time":1366060728}}'
    info = CryptoTicker::BTCe.info(data)

    assert info.has_key?( :high )
    assert info.has_key?( :low  )
    assert info.has_key?( :last )

    assert_equal BigDecimal, info.fetch(:high).class
    assert_equal BigDecimal, info.fetch(:low ).class
    assert_equal BigDecimal, info.fetch(:last).class
  end

  def test_get_class_for
    klass = CryptoTicker::get_class_for('BTC-e')
    assert_equal CryptoTicker::BTCe, klass

    klass = CryptoTicker::get_class_for('BTCe')
    assert_equal CryptoTicker::BTCe, klass

    klass = CryptoTicker::get_class_for('btc-e')
    assert_equal CryptoTicker::BTCe, klass

    klass = CryptoTicker::get_class_for('MtGox')
    assert_equal CryptoTicker::MtGox, klass

    klass = CryptoTicker::get_class_for('mtgox')
    assert_equal CryptoTicker::MtGox, klass

    klass = CryptoTicker::get_class_for('Vircurex')
    assert_equal CryptoTicker::Vircurex, klass

    klass = CryptoTicker::get_class_for('vircurex')
    assert_equal CryptoTicker::Vircurex, klass
  end

end


