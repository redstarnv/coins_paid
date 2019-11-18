# frozen_string_literal: true

describe CoinsPaid, '.qr_code' do
  let(:foreign_id) { 123 }
  let(:coins_paid_address) do
    instance_double CoinsPaid::CoinsPaidAddress,
      currency: 'BTC',
      address: 'abc123'
  end
  subject(:qr_code) do
    described_class.qr_code(
      foreign_id,
      currency: 'BTC',
      label: 'RedStar deposit',
      message: 'Make a deposit to RedStar'
    )
  end

  before do
    allow(CoinsPaid).to receive(:address).with(foreign_id, currency: 'BTC').and_return(coins_paid_address)
  end

  describe '#payment_url' do
    its(:url) { is_expected.to eq 'bitcoin:abc123?label=RedStar+deposit&message=Make+a+deposit+to+RedStar' }
  end
end
