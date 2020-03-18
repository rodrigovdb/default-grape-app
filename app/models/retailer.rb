# frozen_string_literal: true

class Retailer < ActiveRecord::Base
  attr_accessor :password

  has_many :sales

  validates :full_name, uniqueness: true, format: {
    with: /\w+(\s\w+)+/,
    message: 'Invalid full name'
  }

  validates :cpf, uniqueness: true, format: {
    with: /\d{11}/,
    message: 'Invalid CPF format'
  }

  validates :email, uniqueness: true, format: {
    with: /\w+@\w+(\.\w+)+/,
    message: 'Invalid email format'
  }

  validates :password, confirmation: true

  before_save :generate_encrypted_password

  def self.authenticate(cpf:, password:)
    token = MyTokenGenerator.new(cpf, password).token

    user = Retailer.where(cpf: cpf, encrypted_password: token).first

    user || false
  end

  private

  def generate_encrypted_password
    self.encrypted_password = MyTokenGenerator.new(cpf, password).token
  end

  class MyTokenGenerator
    def initialize(*args)
      @cpf, @password = args
    end

    def token
      Digest::MD5.hexdigest(cpf + password)
    end

    private

    attr_reader :cpf, :password
  end
end
