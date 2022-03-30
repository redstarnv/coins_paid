# frozen_string_literal: true

describe CoinsPaid, '.issued_addresses' do
  let(:foreign_id) { 123 }

  it 'returns addresses with requested foreign_id ordered by currency' do
    attrs = {
      foreign_id: foreign_id,
      address: 'addr',
      external_id: 1
    }

    addr1 = CoinsPaid::CoinsPaidAddress.create!(attrs.merge(currency: 'BTC', convert_to: 'EUR'))
    addr2 = CoinsPaid::CoinsPaidAddress.create!(attrs.merge(currency: 'ETH', convert_to: 'EUR'))
    addr3 = CoinsPaid::CoinsPaidAddress.create!(attrs.merge(currency: 'ETH', convert_to: 'ETH'))
    CoinsPaid::CoinsPaidAddress.create!(attrs.merge(currency: 'BTC', convert_to: 'EUR', foreign_id: 555))

    expect(CoinsPaid.issued_addresses(foreign_id)).to eq [addr1, addr3, addr2]
  end
end
