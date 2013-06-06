
deprecated
----------

This module needs a re-write of the API. I initially tried to make it as
minimal as possible, not including any user-agent/page-fetch functionality.
Instead of fetching pages/urls, this lib would leave that to the developer and
only provide a collection of URLs and methods used to parse/retrieve/extract
the data. Since the exchanges each provide RESTful APIs anyway, there's not
much point in keeping this around. Also, there exist other modules which are
dedicated to specific exchanges, and those are more well-written than this. For
example, the ruby-btce module works great for BTC-e. I'm sure there are several
for MtGox. As such, I am expiring this module in favor of those.


CryptoTicker
============

Collection of public data API urls for various online crypto-currency
exchanges, e.g. MtGox, BTC-e, etc.

I tried to follow the UNIX philosophy of "write programs which do one thing and
do it well", so this module doesn't include a user-agent module. It only
provides public data API URL's in one convenient location, and optionally,
parses the data returned from those URLs. You'll have to use this in
conjunction with 'mechanize' or 'net/http' or some other such module to
actually do anything (see [example](#example)).

Installation
------------

    gem install crypto_ticker

Usage
-----

### Example

    require 'crypto_ticker'
    require 'mechanize'
    require 'pp'

    agent = Mechanize.new

    # get MtGox BTC/USD ticker URL:
    url  = CryptoTicker::MtGox.ticker('BTC/USD')
    json = agent.get( url ).body 

    mtgox_data_hash = CryptoTicker::MtGox.info( json )
    pp mtgox_data_hash

Contributing
------------

1. Fork it (Github repo: [homepage][homepage])
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[homepage]: https://github.com/nmarley/crypto_ticker


License
-------
Released under the MIT License.  See the [LICENSE][] file for further details.

[license]: LICENSE.md
