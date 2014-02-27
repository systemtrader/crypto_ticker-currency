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
  # Bitstamp BTC/USD ticker
  #

  class Bitstamp
    include HTTParty

    base_uri "https://www.bitstamp.net"

    parser lambda { |body, format|
      results = {}
      data = JSON.parse(body)

      results[:timestamp]  = Time.at( data.delete("timestamp").to_i )

      results.merge! Hash[ data.map { |k, v| [ k.to_sym, v.to_d ] } ]
      results
    }

    def self.btcusd
      get "/api/ticker/"
    end

  end


  ##
  # BTC-e tickers for various crypto-currencies and retrieval methods

  class BTCe
    include HTTParty

    base_uri "btc-e.com"
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
        get "/api/2/#{pair_sym.to_s}/ticker"
      end

    end

  end

  class Localbitcoins
    include HTTParty

    base_uri "https://localbitcoins.com"
    parser lambda { |body, format|
      results = {}
      data = JSON.parse(body)

      usd = data["USD"]
      results[:last] = usd["rates"]["last"]
      results[:volume] = usd["volume_btc"]
      results
    }

    def self.btcusd
      get "/bitcoinaverage/ticker-all-currencies/"
    end
  end

  class << self
    @@exchange_class = {
      'btce'     => CryptoTicker::BTCe,
      'bitstamp' => CryptoTicker::Bitstamp,
      'localbitcoins' => CryptoTicker::Localbitcoins,
      #'vircurex' => CryptoTicker::Vircurex,
    }

    def get_class_for(exchange_name)
      @@exchange_class[ exchange_name.gsub('-', '').downcase ]
    end

  end

end

