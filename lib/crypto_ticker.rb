
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


  class << self
    @@exchange_class = {
      'btce'     => CryptoTicker::BTCe,
      'mtgox'    => CryptoTicker::MtGox,
      #'vircurex' => CryptoTicker::Vircurex,
      #'bitstamp' => CryptoTicker::Bitstamp,
    }

    def get_class_for(exchange_name)
      @@exchange_class[ exchange_name.gsub('-', '').downcase ]
    end

  end

end

