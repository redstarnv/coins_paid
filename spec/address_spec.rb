# frozen_string_literal: true

describe CoinsPaid, '.address' do
  let(:foreign_key) { 'user-id:2048' }
  let(:currency) { 'BTC' }
  let(:convert_to) { 'EUR' }
  let(:full_address_attributes) do
    {
      foreign_id: foreign_key,
      currency: currency
    }.merge(address_attributes)
  end
  let(:address_attributes) do
    {
      external_id: 1,
      address: '12983h13ro1hrt24it432t',
      tag: 'tag-123',
    }
  end
  subject(:take_address) { described_class.address(foreign_key, currency: currency, convert_to: convert_to) }

  context 'when there is existing record' do
    let!(:address) do
      CoinsPaid::CoinsPaidAddress.create!(full_address_attributes)
    end

    before do
      allow(CoinsPaid::API).to receive(:take_address)
    end

    it 'returns existing record' do
      expect(take_address).to eq address

      expect(CoinsPaid::API).not_to have_received(:take_address)
    end
  end

  context 'when coins paid api responds with error' do
    before do
      allow(CoinsPaid::API).to receive(:take_address).and_raise(CoinsPaid::API::Error)
    end

    it 'raises error' do
      expect { take_address }.to raise_error(CoinsPaid::API::Error)
    end
  end

  context 'when coins paid return valid response' do
    before do
      allow(CoinsPaid::API).to receive(:take_address).and_return(CoinsPaid::API::TakeAddress::Response.new(address_attributes))
    end

    it 'creates new address' do
      expect(take_address).to have_attributes(full_address_attributes)
    end
  end
end
