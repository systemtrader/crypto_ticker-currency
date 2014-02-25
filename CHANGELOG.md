## 0.2.0.beta (2014-02-24)

Bugfixes:

  - remove MtGox

Features:

  - add Bitstamp

## 0.1.0.beta (2013-10-08)

Bugfixes:

  - fix entire (deprecated) module

Features:

  - re-write API (non-backwards-compatible changes)
  - now mixes in HTTParty
  - parser returns numeric values as BigDecimal
  - only BTC-e and MtGox are currently supported

## 0.0.3 (2013-04-21)

Bugfixes:

  -  fix MtGox ticker url

Features:

  - return data values in appropriate format for BTCe.info (BigDecimal, Fixnum, String, etc)
  - added CryptoTicker::get_class_for() method

