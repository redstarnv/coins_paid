# frozen_string_literal: true

describe CoinsPaid, '.address' do
  let(:foreign_id) { 'user-id:2048' }
  let(:currency) { 'BTC' }
  let(:convert_to) { 'EUR' }
  let(:address_attributes) do
    {
      external_id: 1,
      address: '12983h13ro1hrt24it432t',
      tag: 'tag-123'
    }
  end
  let(:api_request_args) { { foreign_id: foreign_id, currency: currency, convert_to: convert_to } }

  subject(:take_address) { described_class.address(foreign_id, currency: currency, convert_to: convert_to) }

  context 'when there is a previously stored address record' do
    let(:stored_address_attributes) do
      address_attributes.merge(
        foreign_id: foreign_id,
        currency: currency,
        convert_to: recorded_convert_to
      )
    end

    let!(:stored_address) do
      CoinsPaid::CoinsPaidAddress.create!(stored_address_attributes)
    end

    before do
      allow(CoinsPaid::API).to receive(:take_address).and_return(
        CoinsPaid::API::TakeAddress::Response.new(address_attributes)
      )
    end

    context 'with the same convert_to value' do
      let(:recorded_convert_to) { convert_to }

      it 'returns existing record' do
        expect do
          expect(take_address).to eq stored_address
        end.to_not change(CoinsPaid::CoinsPaidAddress, :count)
        expect(CoinsPaid::API).not_to have_received(:take_address)
      end
    end

    context 'with a different convert_to value' do
      let(:recorded_convert_to) { 'DOGE' }

      it 'requests and records new address' do
        expect do
          new_address_attrs = stored_address_attributes.merge(convert_to: convert_to)
          expect(take_address).to have_attributes(new_address_attrs)
        end.to change(CoinsPaid::CoinsPaidAddress, :count).by(1)
        expect(CoinsPaid::API).to have_received(:take_address).with(api_request_args)
      end
    end
  end

  context 'when there is no recorded address' do
    context 'and coins paid api responds with error' do
      before do
        allow(CoinsPaid::API).to receive(:take_address).and_raise(CoinsPaid::API::Error)
      end

      it 'raises error' do
        expect { take_address }.to raise_error(CoinsPaid::API::Error)
      end
    end

    context 'and coins paid returns valid response' do
      before do
        allow(CoinsPaid::API).to receive(:take_address).and_return(
          CoinsPaid::API::TakeAddress::Response.new(address_attributes)
        )
      end

      let(:new_address_attrs) do
        address_attributes.merge(
          foreign_id: foreign_id,
          currency: currency,
          convert_to: convert_to
        )
      end

      it 'creates new address' do
        expect do
          expect(take_address).to have_attributes(new_address_attrs)
        end.to change(CoinsPaid::CoinsPaidAddress, :count).by(1)
        expect(CoinsPaid::API).to have_received(:take_address).with(api_request_args)
      end
    end
  end
end
