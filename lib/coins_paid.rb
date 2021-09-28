# frozen_string_literal: true
require 'dry-struct'
require 'dry-initializer'
require_relative 'coins_paid/address'
require_relative 'coins_paid/coins_paid_address'
require_relative 'coins_paid/qr_code'

module CoinsPaid
  module_function

  UnknownCurrency = Class.new RuntimeError

  DEFAULT_CONVERT_TO = ENV['COINS_PAID_CURRENCY']

  ADDRESS_PREFIXES = {
    'BTC' => 'bitcoin',
    'BCH' => 'bitcoincash',
    'DOGE' => 'doge',
    'ETH' => 'ethereum',
    'EURTE' => 'ethereum',
    'LTC' => 'litecoin',
    'USDT' => 'bitcoin',
    'USDTE' => 'ethereum',
    'TRX' => 'tron',
    'USDTT' => 'tron'
  }.freeze

  def address(foreign_id, currency:)
    Address.new(foreign_id: foreign_id, currency: currency, convert_to: DEFAULT_CONVERT_TO).call
  end

  def qr_code(player_id, currency:, label:, message:)
    QrCode.new(player_id, currency: currency, label: label, message: message)
  end

  def currency(name)
    CoinsPaid::API.currencies_list.find { |item| item.currency == name } || raise(UnknownCurrency, name)
  end

  def issued_addresses(foreign_id)
    CoinsPaidAddress.where(foreign_id: foreign_id).order(:currency)
  end
end
