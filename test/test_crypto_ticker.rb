require 'minitest_helper'
require 'uri'
require 'json'
require 'pp'

module CryptoTickerTestHelper
  def common_tests
    assert !@result.has_key?("error")
    %i[ high low avg vol vol_cur last 
        buy sell updated server_time ].each do |sym|
      assert @result.has_key?(sym)
    end
    assert @result[:high] >= @result[:low]
  end
end

class TestCryptoTicker < Minitest::Test
  include CryptoTickerTestHelper

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

  def xtest_btce_parser
    data = '{"ticker":{"high":99,"low":81,"avg":90,"vol":1857509.30091,"vol_cur":20229.18878,"last":84.5,"buy":84.873,"sell":84.01,"server_time":1366060728}}'
    info = CryptoTicker::BTCe.info(data)

    assert info.has_key?( :high )
    assert info.has_key?( :low  )
    assert info.has_key?( :last )

    assert_equal BigDecimal, info.fetch(:high).class
    assert_equal BigDecimal, info.fetch(:low ).class
    assert_equal BigDecimal, info.fetch(:last).class
  end

  def xtest_get_class_for
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


