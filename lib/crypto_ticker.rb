
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
    @@valid_pairs = %w[ BTC/USD LTC/USD NMC/USD ]

    class << self

      # return a ticker URL for a given crypto FX pair
      def ticker(base, quote='')
        pair = CryptoTicker::makepair(base, quote)
        if @@valid_pairs.include?( pair )
          "http://data.mtgox.com/api/2/" + pair.split('/').join('') +
            "/money/ticker"
        end
      end

      def trades(base, quote='')
        pair = CryptoTicker::makepair(base, quote)
        if @@valid_pairs.include?( pair )
          "http://data.mtgox.com/api/2/" + pair.split('/').join('') +
            "/money/trades/fetch"
        end
      end

      def depth(base, quote='')
        pair = CryptoTicker::makepair(base, quote)
        if @@valid_pairs.include?( pair )
          "http://data.mtgox.com/api/2/" + pair.split('/').join('') +
            "/money/depth/fetch"
        end
      end

      # Accepts JSON retrieved from the MtGox ticker URL, returns last trade
      # amount (denominated in counter currency) as a BigDecimal.
      # eg: BTC/USD ticker will return amount in USD
      def last(json)
        hash = JSON.parse(json)
        if hash['result'] === 'success'
          hash['data']['last']['value'].to_d
        end
      end

      def info(json)
        hash = JSON.parse(json)
        info = {}
        if hash['result'] === 'success'
          hash['data'].each do |k,v|
            if v.class.to_s.eql?( 'Hash' )
              info[k.to_sym] = v['value'].to_d
            end
          end
        end

        # return either nil or the hash w/data
        info.empty? ? nil : info
      end
    end

  end


  ##
  # BTC-e tickers for various crypto-currencies and retrieval methods

  class BTCe
    include HTTParty

    base_uri "btc-e.com/api/2"
    parser lambda { |body, format|
      results = {}
      data = JSON.parse(body)

      ticker = data["ticker"]

      results[:updated]     = Time.at(ticker.delete("updated"))
      results[:server_time] = Time.at(ticker.delete("server_time"))
      results.merge! Hash[ ticker.map { |k,v| [ k.to_sym, v.to_d ] } ]
      results
    }

    # CryptoTicker::BTCe.btcusd.parsed_response
    def self.btcusd
      request :btc_usd
    end

    def self.ltcusd
      request :ltc_usd
    end

    def self.ltcbtc
      request :ltc_btc
    end

    def self.btcrur
      request :btc_rur
    end

    def self.btceur
      request :btc_eur
    end

    def self.ltcrur
      request :ltc_rur
    end

    def self.nmcbtc
      request :nmc_btc
    end

    def self.nvcbtc
      request :nvc_btc
    end

    def self.trcbtc
      request :trc_btc
    end

    def self.ppcbtc
      request :ppc_btc
    end

    def self.ftcbtc
      request :ftc_btc
    end

    def self.usdrur
      request :usd_rur
    end

    def self.eurusd
      request :eur_usd
    end


    class << self
      def request pair_sym
        get "/#{pair_sym.to_s}/ticker"
      end

      protected :request
    end

    #@@valid_pairs = %w[ BTC/USD BTC/RUR BTC/EUR LTC/BTC LTC/USD LTC/RUR NMC/BTC
    #                    USD/RUR EUR/USD NVC/BTC TRC/BTC PPC/BTC RUC/BTC ]

    #class << self

      #def ticker(base, quote='')
      #  pair = CryptoTicker::makepair(base, quote)
      #  if @@valid_pairs.include?( pair )
      #    "https://btc-e.com/api/2/#{pair.to_sym}/ticker"
      #  end
      #end

      #def trades(base, quote='')
      #  pair = CryptoTicker::makepair(base, quote)
      #  if @@valid_pairs.include?( pair )
      #    "https://btc-e.com/api/2/#{pair.to_sym}/trades"
      #  end
      #end

      #def depth(base, quote='')
      #  pair = CryptoTicker::makepair(base, quote)
      #  if @@valid_pairs.include?( pair )
      #    "https://btc-e.com/api/2/#{pair.to_sym}/depth"
      #  end
      #end

      # Accepts JSON retrieved from the appropriate BTC-e ticker URL, returns
      # last trade amount (denominated in counter currency) as a float.
      # eg: BTC/USD ticker will return amount in USD
      #     NMC/BTC ticker will return amount in BTC
      #def last(json)
      #  hash = JSON.parse(json)
      #  hash['ticker']['last'].to_d
      #end

#      def info(json)
#        hash = JSON.parse(json)
#        info = {}
#        # TODO: recursively process Arrays, Hashes, Strings, Fixnums...
#        if hash.has_key?('ticker')
#          hash['ticker'].keys.each do |key|
#            val  = hash['ticker'][key]
#            info[key.to_sym] = val.send(@@ret_fcns[@@ret_types[key]])
#          end
#        end
#        info
#      end

  #  end

  end


  ##
  # Vircurex ticker API and retrieval method
  class Vircurex

    class << self
      # accept [base, quote] args for consistency with other classes, but ignore
      # them
      def ticker(base='', quote='')
        # this one gets everything...
        'https://vircurex.com/api/get_info_for_currency.json'
      end

      # Accepts JSON retrieved from the Vircurex ticker URL, as well as a
      # currency pair (specified as 2 arguments, a base currency and a quote
      # currency). Returns last trade amount in quote currency.
      def getpair(json, base, quote)
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

      # Accepts JSON retrieved from the Vircurex ticker URL, as well as a
      # currency pair (specified as 2 arguments, a base currency and a quote
      # currency). Returns last trade amount in quote currency.
      def pair_info(json, base, quote)
        hash = JSON.parse(json)

        # upcase currency pair inputs
        base.upcase!
        quote.upcase!

        # default value (may change this to just throw an exception)
        info = {}

        # if currency pair exists, return value of last trade
        if hash.has_key?(base) && hash[base].has_key?( quote )
           info = hash[base][quote]
        end

        info
      end

    end

  end


  class Bitstamp
    # this exchange only has BTC/USD
    class << self
      def ticker(base='BTC', quote='USD')
        'https://www.bitstamp.net/api/ticker/'
      end

      def info(json)
        info = {}
        JSON.parse(json).each do |k,v|
          info[k.to_sym] = v.to_d
        end
        info
      end

      def last(json)
        self.info(json)[:last]
      end

    end

  end

  class << self
    @@h = {
      'btce'     => CryptoTicker::BTCe,
      'mtgox'    => CryptoTicker::MtGox,
      'vircurex' => CryptoTicker::Vircurex,
      'bitstamp' => CryptoTicker::Bitstamp,
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

