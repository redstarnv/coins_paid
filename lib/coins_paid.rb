# frozen_string_literal: true
require 'dry-struct'
require 'dry-initializer'
require_relative 'coins_paid/address'
require_relative 'coins_paid/coins_paid_address'

module CoinsPaid
  module_function

  UnknownCurrency = Class.new RuntimeError

  def address(foreign_id, currency:, convert_to:)
    Address.new(foreign_id: foreign_id, currency: currency, convert_to: convert_to).call
  end

  def currency(name)
    CoinsPaid::API.currencies_list.find { |item| item.currency == name } || raise(UnknownCurrency, name)
  end

  def issued_addresses(foreign_id)
    CoinsPaidAddress.where(foreign_id: foreign_id).order(:currency)
  end
end
