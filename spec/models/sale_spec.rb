# frozen_string_literal: true

require './app.rb'

describe Sale do
  context 'Validation' do
    let(:retailer) { create(:retailer) }

    it 'fails if miss sale_code' do
      params = attributes_for(:sale)
      params.delete(:sale_code)

      sale = Sale.create(params.merge(retailer: retailer))

      expect(sale).not_to be_valid
      expect(sale.errors.messages).to eq(sale_code: ["can't be blank"])
    end

    it 'fails if sales_code has already been taken' do
      create(:sale, sale_code: 'foobar')
      params = attributes_for(:sale, sale_code: 'foobar')

      sale = Sale.create(params.merge(retailer: retailer))

      expect(sale).not_to be_valid
      expect(sale.errors.messages).to eq(sale_code: ['has already been taken'])
    end

    it 'fails if miss amount' do
      params = attributes_for(:sale)
      params.delete(:amount)

      sale = Sale.create(params.merge(retailer: retailer))

      expect(sale).not_to be_valid
      expect(sale.errors.messages).to eq(amount: ['is not a number'])
    end

    it 'fails if amount is invalid' do
      params = attributes_for(:sale, amount: 'asdf')

      sale = Sale.create(params.merge(retailer: retailer))

      expect(sale.errors.messages).to eq(amount: ['is not a number'])
    end

    it 'fails if miss sold_at' do
      params = attributes_for(:sale)
      params.delete(:sold_at)

      sale = Sale.create(params.merge(retailer: retailer))

      expect(sale.errors.messages).to eq(sold_at: ["can't be blank"])
    end

    it 'does not fail if params are valid' do
      params = attributes_for(:sale)

      sale = Sale.create(params.merge(retailer: retailer))

      expect(sale.id).not_to be_nil
    end
  end

  context 'Status' do
    it 'Creates with validating status by default' do
      retailer = create(:retailer)
      params = attributes_for(:sale).merge(retailer: retailer)

      sale = Sale.create(params)

      expect(sale).to be_validating
    end

    it 'Creates with approved status for a specific CPF' do
      retailer = create(:retailer, cpf: '15350946056')
      params = attributes_for(:sale).merge(retailer: retailer)

      sale = Sale.create(params)

      expect(sale).to be_approved
    end
  end

  describe '#cashback_factor' do
    it 'receives 10 when amount <= 1000' do
      sale1 = create(:sale, amount: 0.01)
      sale2 = create(:sale, amount: 999.99)
      sale3 = create(:sale, amount: 1000.00)
      sale4 = create(:sale, amount: 1000)

      [sale1, sale2, sale3, sale4].each { |sale| expect(sale.cashback_factor).to be 10 }
    end

    it 'receives 15 when 1000 < amount <= 1500' do
      sale1 = create(:sale, amount: 1000.01)
      sale2 = create(:sale, amount: 1499.99)
      sale3 = create(:sale, amount: 1500.00)
      sale4 = create(:sale, amount: 1500)

      [sale1, sale2, sale3, sale4].each { |sale| expect(sale.cashback_factor).to be 15 }
    end

    it 'receives 20 when amount > 1500' do
      sale1 = create(:sale, amount: 1500.01)
      sale2 = create(:sale, amount: 1600)
      sale3 = create(:sale, amount: 1700.1)

      [sale1, sale2, sale3].each { |sale| expect(sale.cashback_factor).to be 20 }
    end
  end

  describe '#cashback' do
    it 'calculates cashback using factor and rounding' do
      sale = create(:sale, amount: 123.44)

      expect(sale.cashback.to_f).to eq 12.34
    end
  end
end
