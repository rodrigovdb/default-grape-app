# frozen_string_literal: true

require 'models/concerns/public_id'

class User < ActiveRecord::Base
  include PublicId
  attr_accessor :password

  validates :email, uniqueness: true, format: {
    with: /\w+@\w+(\.\w+)+/,
    message: 'Invalid email format'
  }

  validates :password, confirmation: true

  before_create :generate_encrypted_password
  after_create  :generate_stuffs

  def self.authenticate(email:, password:)
    password = MyTokenGenerator.new(email + password).token

    user = User.where(email:, encrypted_password: password).first

    user || false
  end

  private

  def generate_encrypted_password
    self.encrypted_password = MyTokenGenerator.new(email + password).token
  end

  def generate_stuffs
    self.token = MyTokenGenerator.new(id.to_s).token
    self.public_id ||= generate_public_id

    save
  end

  class MyTokenGenerator
    def initialize(str)
      @str = str
    end

    def token
      Digest::MD5.hexdigest(str)
    end

    private

    attr_reader :str
  end
end
