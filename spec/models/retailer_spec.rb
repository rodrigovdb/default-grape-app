# frozen_string_literal: true

require './app.rb'

describe Retailer do
  describe '.authenticate' do
    let(:retailer) { create(:retailer, password: 'rapadura') }

    it 'returns retailer instance if credentials are right' do
      expect(Retailer.authenticate(cpf: retailer.cpf, password: 'rapadura')).to eq retailer
    end

    it 'returns false if credentials are not right' do
      expect(Retailer.authenticate(cpf: retailer.cpf, password: 'foobar')).to be_falsey
    end
  end

  context 'Encrypted password' do
    it 'digest password to create encrypted_password' do
      params = attributes_for(:retailer)

      retailer = Retailer.create(params)

      expect(retailer.encrypted_password).not_to be_nil
    end
  end

  context 'Validation' do
    it 'fails if miss full_name' do
      params = attributes_for(:retailer)
      params.delete(:full_name)

      retailer = Retailer.create(params)

      expect(retailer).not_to be_valid
      expect(retailer.errors.messages).to eq(full_name: ['Invalid full name'])
    end

    it 'fails if full_name has an invalid format' do
      params = attributes_for(:retailer, full_name: 'John')

      retailer = Retailer.create(params)

      expect(retailer).not_to be_valid
      expect(retailer.errors.messages).to eq(full_name: ['Invalid full name'])
    end

    it 'fails if full_name has already been taken' do
      create(:retailer, full_name: 'John Doe')
      params = attributes_for(:retailer, full_name: 'John Doe')

      retailer = Retailer.create(params)

      expect(retailer).not_to be_valid
      expect(retailer.errors.messages).to eq(full_name: ['has already been taken'])
    end

    it 'fails if miss cpf' do
      params = attributes_for(:retailer)
      params.delete(:cpf)

      retailer = Retailer.create(params)

      expect(retailer).not_to be_valid
      expect(retailer.errors.messages).to eq(cpf: ['Invalid CPF format'])
    end

    it 'fails if cpf has an invalid format' do
      params = attributes_for(:retailer, cpf: '111.111.111-11')

      retailer = Retailer.create(params)

      expect(retailer).not_to be_valid
      expect(retailer.errors.messages).to eq(cpf: ['Invalid CPF format'])
    end

    it 'fails if cpf has already been taken' do
      create(:retailer, cpf: '11111111111')
      params = attributes_for(:retailer, cpf: '11111111111')

      retailer = Retailer.create(params)

      expect(retailer).not_to be_valid
      expect(retailer.errors.messages).to eq(cpf: ['has already been taken'])
    end

    it 'fails if miss email' do
      params = attributes_for(:retailer)
      params.delete(:email)

      retailer = Retailer.create(params)

      expect(retailer).not_to be_valid
      expect(retailer.errors.messages).to eq(email: ['Invalid email format'])
    end

    it 'fails if email has an invalid format' do
      params = attributes_for(:retailer, email: 'john@doe')

      retailer = Retailer.create(params)

      expect(retailer).not_to be_valid
      expect(retailer.errors.messages).to eq(email: ['Invalid email format'])
    end

    it 'fails if email has already been taken' do
      create(:retailer, email: 'john@doe.com')
      params = attributes_for(:retailer, email: 'john@doe.com')

      retailer = Retailer.create(params)

      expect(retailer).not_to be_valid
      expect(retailer.errors.messages).to eq(email: ['has already been taken'])
    end

    it 'fails if password does not match' do
      params = attributes_for(:retailer, password: 'foobar').merge(password_confirmation: 'foos')

      retailer = Retailer.create(params)

      expect(retailer).not_to be_valid
      expect(retailer.errors.messages).to eq(password_confirmation: ["doesn't match Password"])
    end

    it 'does not fail with valid params' do
      params = attributes_for(:retailer)

      retailer = Retailer.create(params)

      expect(retailer).to be_valid
      expect(retailer.id).not_to be_nil
    end
  end
end
