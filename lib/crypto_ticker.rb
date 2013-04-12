
require 'crypto_ticker/version'
require 'json'
require 'bigdecimal'
require 'bigdecimal/util'

##
# This module bundles crypto-currency exchange public data API sources. (e.g.
# Bitcoin exchange rate, Litecoin, etc.)

module CryptoTicker

  class FXPair < String
    def to_sym
      self.downcase.split('/').join('_').to_sym
    end
  end
  class Symbol
    def to_fxpair
      FXPair.new( self.to_s.split('_').join('/').upcase )
    end
  end

  def self.makepair(base, quote='')
    if base =~ /([a-z]{3})\/([a-z]{3})/i
      base, quote = $1, $2
    end
    # assume user entered either a fxpair array or a fxpair string
    # TODO: error-checking on input
    pair = FXPair.new("#{base.upcase}/#{quote.upcase}")
    pair
  end


  ##
  # MtGox BTC/USD ticker and retrieval method
  #
  # note: The official MtGox API documentation is very sparse, and some methods
  # are published but undocumented. The 'ticker' method should work, others may
  # lag or return large amounts of data.

  class MtGox
    @@valid_pairs = %w[ BTC/USD LTC/USD NMC/USD ]

    # return a ticker URL for a given crypto FX pair
    def self.ticker(base, quote='')
      pair = CryptoTicker::makepair(base, quote)
      if @@valid_pairs.include?( pair )
        "http://data.mtgox.com/api/2/" + pair.split('/').join('') +
          "/money/ticker_fast"
      end
    end

    def self.trades(base, quote='')
      pair = CryptoTicker::makepair(base, quote)
      if @@valid_pairs.include?( pair )
        "http://data.mtgox.com/api/2/" + pair.split('/').join('') +
          "/money/trades/fetch"
      end
    end

    def self.depth(base, quote='')
      pair = CryptoTicker::makepair(base, quote)
      if @@valid_pairs.include?( pair )
        "http://data.mtgox.com/api/2/" + pair.split('/').join('') +
          "/money/depth/fetch"
      end
    end

    # Accepts JSON retrieved from the MtGox ticker URL, returns last trade
    # amount (denominated in counter currency) as a BigDecimal.
    # eg: BTC/USD ticker will return amount in USD
    def self.last(json)
      hash = JSON.parse(json)
      if hash['result'] === 'success'
        hash['data']['last']['value'].to_d
      end
    end

    def self.info(json)
      hash = JSON.parse(json)
      info = {}
      if hash['result'] === 'success'
        hash['data'].each do |k,v|
          if v.class.to_s.eql?( 'Hash' )
            info[k.to_sym] = v['value'].to_d
          end
        end
      end
      info
    end
  end


  ##
  # BTC-e tickers for various crypto-currencies and retrieval methods

  class BTCe
    @@valid_pairs = %w[ BTC/USD BTC/RUR BTC/EUR LTC/BTC LTC/USD LTC/RUR NMC/BTC
                        USD/RUR EUR/USD NVC/BTC TRC/BTC PPC/BTC RUC/BTC ]

    def self.ticker(base, quote='')
      pair = CryptoTicker::makepair(base, quote)
      if @@valid_pairs.include?( pair )
        "https://btc-e.com/api/2/#{pair.to_sym}/ticker"
      end
    end

    def self.trades(base, quote='')
      pair = CryptoTicker::makepair(base, quote)
      if @@valid_pairs.include?( pair )
        "https://btc-e.com/api/2/#{pair.to_sym}/trades"
      end
    end

    def self.depth(base, quote='')
      pair = CryptoTicker::makepair(base, quote)
      if @@valid_pairs.include?( pair )
        "https://btc-e.com/api/2/#{pair.to_sym}/depth"
      end
    end

    # Accepts JSON retrieved from the appropriate BTC-e ticker URL, returns
    # last trade amount (denominated in counter currency) as a float.
    # eg: BTC/USD ticker will return amount in USD
    #     NMC/BTC ticker will return amount in BTC
    def self.last(json)
      hash = JSON.parse(json)
      hash['ticker']['last'].to_d
    end
  end


  ##
  # Vircurex ticker API and retrieval method
  class Vircurex

    # accept [base, quote] args for consistency with other classes, but ignore
    # them
    def self.ticker(base='', quote='')
      # this one gets everything...
      'https://vircurex.com/api/get_info_for_currency.json'
    end

    # Accepts JSON retrieved from the Vircurex ticker URL, as well as a
    # currency pair (specified as 2 arguments, a base currency and a quote
    # currency). Returns last trade amount in quote currency.
    def self.getpair(json, base, quote)
      hash = JSON.parse(json)

      # upcase currency pair inputs
      base.upcase!
      quote.upcase!

      # default value (may change this to just throw an exception)
      last = 0.0

      # if currency pair exists, return value of last trade
      if hash.has_key?(base) && hash[base].has_key?( quote ) &&
         hash[base][quote].has_key?('last_trade')
          last = hash[base][quote]['last_trade'].to_d
      end

      last
    end
  end


  class Bitstamp
    # this exchange only has BTC/USD
    def self.ticker(base='BTC', quote='USD')
      'https://www.bitstamp.net/api/ticker/'
    end

    def self.info(json)
      info = {}
      JSON.parse(json).each do |k,v|
        info[k.to_sym] = v.to_d
      end
      info
    end

    def self.last(json)
      self.info(json)[:last]
    end

  end
end

