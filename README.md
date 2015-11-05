# CryptoTicker {deprecated - see note}

Provides a simple, uniform method for accessing public ticker APIs for various
online crypto-currency (e.g. Bitcoin, Litecoin) exchanges (e.g. Bitstamp, BTC-e,
etc.).

## Deprecated

I don't use this and don't recommend it. 'Twas made when I started learning
Ruby, but doesn't offer any significant functionality.


## Installation

    gem install crypto_ticker

# Usage

### Synopsis

  The ticker functions (btcusd, ltcusd, etc) return an HTTParty::Response, and
  this module includes a parser for the body. The parser returns numeric data
  as BigDecimal values, which can be manipulated however you like. Hash keys
  differ for each exchange, but :high, :low, and :last should always exist in
  the response.

### Example

    require 'crypto_ticker'

    # get spot BTC/USD price from BTC-e exchange:
    h = CryptoTicker::BTCe.btcusd.parsed_response

    puts <<-EOF
    BTC/USD stats:

           high: #{h[:high].to_f}
            low: #{h[:low].to_f}
            avg: #{h[:avg].to_f}
            vol: #{h[:vol].to_f}
        vol_cur: #{h[:vol_cur].to_f}
           last: #{h[:last].to_f}
            buy: #{h[:buy].to_f}
           sell: #{h[:sell].to_f}
        updated: #{h[:updated].to_f}
    server_time: #{h[:server_time]}
    EOF
