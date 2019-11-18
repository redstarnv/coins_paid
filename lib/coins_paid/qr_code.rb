# frozen_string_literal: true

module CoinsPaid
  class QrCode
    include Dry::Initializer.define -> do
      param :player_id
      option :currency
      option :label
      option :message
    end

    def url
      "#{token_type}:#{address}?label=#{encode(label)}&message=#{encode(message)}"
    end

    def address
      @address ||= CoinsPaid.address(player_id, currency: currency).address
    end

    def svg
      RQRCode::QRCode.new(url).as_svg(
        offset: 0,
        color: '000',
        shape_rendering: 'crispEdges',
        module_size: 3,
        standalone: true
      )
    end

    private

    def token_type
      CRYPTO_CURRENCIES.fetch(currency)
    end

    def encode(string)
      URI.encode_www_form_component(string)
    end
  end
end
