# frozen_string_literal: true

describe CoinsPaid, '.qr_code' do
  let(:foreign_id) { 123 }
  let(:currency) { 'BTC' }
  let(:address) { 'abc123' }
  let(:coins_paid_address) do
    instance_double CoinsPaid::CoinsPaidAddress,
                    currency: currency,
                    address: address
  end
  subject(:qr_code) do
    described_class.qr_code(
      foreign_id,
      currency: currency,
      label: 'RedStar deposit',
      message: 'Make a deposit to RedStar'
    )
  end

  before do
    allow(CoinsPaid).to receive(:address).with(foreign_id, currency: currency).and_return(coins_paid_address)
  end

  context 'it is known how to build payment url for the currency' do
    let(:currency) { 'BTC' }
    let(:url) { "bitcoin:#{address}?label=RedStar+deposit&message=Make+a+deposit+to+RedStar" }

    describe '#url' do
      its(:url) { is_expected.to eq url }
    end

    describe '#svg' do
      it 'encodes payment url' do
        expect(RQRCode::QRCode).to receive(:new).with(url).and_call_original
        qr_code.svg
      end
    end
  end

  context 'it is not known how to build payment url for the currency' do
    let(:currency) { 'BNB' }

    describe '#url' do
      its(:url) { is_expected.to be_nil }
    end

    describe '#svg' do
      it 'encodes payment address' do
        expect(RQRCode::QRCode).to receive(:new).with(address).and_call_original
        qr_code.svg
      end
    end
  end

  context '#address' do
    its(:address) { is_expected.to eq coins_paid_address }
  end
end
