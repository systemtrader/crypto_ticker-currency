
require 'crypto_ticker/version'
require 'json'
require 'bigdecimal'
require 'bigdecimal/util'
require 'httparty'
require 'time'

##
# This module bundles crypto-currency exchange public data API sources. (e.g.
# Bitcoin exchange rate, Litecoin, etc.)
#
# Provides a uniform method for accessing public ticker APIs for various
# crypto exchanges.

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

  ##
  # MtGox BTC/USD ticker and retrieval method
  #
  # note: The official MtGox API documentation is very sparse, and some methods
  # are published but undocumented. The 'ticker' method should work, others may
  # lag or return large amounts of data.

  class MtGox
    include HTTParty

    base_uri "https://data.mtgox.com/api/2"

    parser lambda { |body, format|
      results = {}
      data = JSON.parse(body)

      return data if data.fetch("result", nil) != "success"

      data = data["data"]
      results[:item] = data.delete("item")
      results[:now]  = Time.at( data.delete("now")[0..9].to_i )

      results.merge! Hash[ data.map { |k, v| [ k.to_sym, v["value"].to_d ] } ]
      results
    }

    class << self

      def btcusd
        request :btcusd
      end

      protected
      def request pair_sym
        get "/#{pair_sym.to_s.upcase}/money/ticker"
      end
    end

  end


  ##
  # BTC-e tickers for various crypto-currencies and retrieval methods

  class BTCe
    include HTTParty

    base_uri "btc-e.com/api/2"
    parser lambda { |body, format|
      return JSON.parse(body) if body.include?('error')

      results = {}
      data = JSON.parse(body)

      ticker = data["ticker"]

      results[:updated]     = Time.at(ticker.delete("updated"))
      results[:server_time] = Time.at(ticker.delete("server_time"))
      results.merge! Hash[ ticker.map { |k,v| [ k.to_sym, v.to_d ] } ]
      results
    }

    class << self

      %w[ btcusd ltcusd ltcbtc btcrur btceur ltcrur nmcbtc nvcbtc trcbtc ppcbtc
          ftcbtc usdrur eurusd cncbtc ].each do |meth|
        define_method(meth) do
          request meth.insert(3, "_").to_sym
        end
      end

      protected
      def request pair_sym
        get "/#{pair_sym.to_s}/ticker"
      end

    end

  end

#  ##
#  # Vircurex ticker API and retrieval method
#  class Vircurex
#
#    class << self
#      # accept [base, quote] args for consistency with other classes, but ignore
#      # them
#      def ticker(base='', quote='')
#        # this one gets everything...
#        'https://vircurex.com/api/get_info_for_currency.json'
#      end
#
#      # Accepts JSON retrieved from the Vircurex ticker URL, as well as a
#      # currency pair (specified as 2 arguments, a base currency and a quote
#      # currency). Returns last trade amount in quote currency.
#      def getpair(json, base, quote)
#        hash = JSON.parse(json)
#
#        # upcase currency pair inputs
#        base.upcase!
#        quote.upcase!
#
#        # default value (may change this to just throw an exception)
#        last = 0.0
#
#        # if currency pair exists, return value of last trade
#        if hash.has_key?(base) && hash[base].has_key?( quote ) &&
#           hash[base][quote].has_key?('last_trade')
#            last = hash[base][quote]['last_trade'].to_d
#        end
#
#        last
#      end
#
#      # Accepts JSON retrieved from the Vircurex ticker URL, as well as a
#      # currency pair (specified as 2 arguments, a base currency and a quote
#      # currency). Returns last trade amount in quote currency.
#      def pair_info(json, base, quote)
#        hash = JSON.parse(json)
#
#        # upcase currency pair inputs
#        base.upcase!
#        quote.upcase!
#
#        # default value (may change this to just throw an exception)
#        info = {}
#
#        # if currency pair exists, return value of last trade
#        if hash.has_key?(base) && hash[base].has_key?( quote )
#           info = hash[base][quote]
#        end
#
#        info
#      end
#
#    end
#
#  end
#
#
#  class Bitstamp
#    # this exchange only has BTC/USD
#    class << self
#      def ticker(base='BTC', quote='USD')
#        'https://www.bitstamp.net/api/ticker/'
#      end
#
#      def info(json)
#        info = {}
#        JSON.parse(json).each do |k,v|
#          info[k.to_sym] = v.to_d
#        end
#        info
#      end
#
#      def last(json)
#        self.info(json)[:last]
#      end
#
#    end
#
#  end

  class << self
    @@h = {
      'btce'     => CryptoTicker::BTCe,
      'mtgox'    => CryptoTicker::MtGox,
      #'vircurex' => CryptoTicker::Vircurex,
      #'bitstamp' => CryptoTicker::Bitstamp,
    }
    def get_class_for(exchange_name)
      @@h[ exchange_name.gsub('-', '').downcase ]
    end

    def makepair(base, quote='')
      if base =~ /([a-z]{3})\/([a-z]{3})/i
        base, quote = $1, $2
      end
      # assume user entered either a fxpair array or a fxpair string
      # TODO: error-checking on input
      pair = FXPair.new("#{base.upcase}/#{quote.upcase}")
      pair
    end

  end

end

