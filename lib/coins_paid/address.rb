# frozen_string_literal: true

module CoinsPaid
  class Address
    module Types
      include Dry.Types()
    end

    class Data < Dry::Struct
      attribute :foreign_id, Types::Coercible::String
      attribute :currency, Types::String
      attribute :convert_to, Types::String
    end

    include Dry::Initializer.define -> do
      param :request_data, Data
    end

    def call
      ActiveRecord::Base.transaction do
        lookup_attrs = request_data.attributes.slice(:foreign_id, :convert_to, :currency)
        CoinsPaidAddress.lock.find_or_create_by!(lookup_attrs) do |address|
          response = CoinsPaid::API.take_address(request_data.attributes)
          address.assign_attributes(response.attributes)
        end
      end
    end
  end
end
