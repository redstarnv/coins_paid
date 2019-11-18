# frozen_string_literal: true

describe CoinsPaid, '.currency' do
  let(:eth) { instance_double(CoinsPaid::API::Currency, currency: 'ETH') }

  subject(:currency) { described_class.currency(eth.currency) }

  context 'when CoinsPaid API responds correctly' do
    before do
      allow(CoinsPaid::API).to receive(:currencies_list) { currencies }
    end

    context 'and currency exists at CoinsPaid' do
      let(:currencies) do
        [eth, instance_double(CoinsPaid::API::Currency, currency: 'm' + eth.currency)]
      end

      it 'returns requested currency details' do
        expect(currency).to eq eth
      end
    end

    context 'and currency does not exist at CoinsPaid' do
      let(:currencies) do
        [instance_double(CoinsPaid::API::Currency, currency: 'm' + eth.currency)]
      end

      it 'errors' do
        expect { currency }.to raise_error(CoinsPaid::UnknownCurrency)
      end
    end
  end

  context 'when coins paid api errors' do
    before do
      allow(CoinsPaid::API).to receive(:currencies_list).and_raise(CoinsPaid::API::Error)
    end

    it 're-raises error' do
      expect { currency }.to raise_error(CoinsPaid::API::Error)
    end
  end
end
