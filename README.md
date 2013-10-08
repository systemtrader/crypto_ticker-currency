
# CryptoTicker

Provides a simple, uniform method for accessing public ticker APIs for various
online crypto-currency (e.g. Bitcoin, Litecoin) exchanges (e.g. MtGox, BTC-e,
etc.).

## Revived!

Like a phoenix, risen from the ashes, so also has this gem had a rebirth!
Probably not, actually... but I can't find any other BTC-e gems out there that
I actually like that use the public ticker API. So for now I will be
using/contributing to _this_ gem.

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


## Contributing

1. Fork it (Github repo: [homepage][homepage])
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[homepage]: https://github.com/nmarley/crypto_ticker


## License

Released under the MIT License.  See the [LICENSE][] file for further details.

[license]: LICENSE.md
