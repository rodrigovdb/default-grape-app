# frozen_string_literal: true

class Sale < ActiveRecord::Base
  belongs_to :retailer

  validates :sale_code, presence: true, uniqueness: true
  validates :amount,    numericality: true
  validates :sold_at,   presence: true
  validates :retailer,  presence: true

  enum status: %i[validating approved]

  before_save :handle_status

  def cashback
    (amount * cashback_factor / 100).round(2)
  end

  def cashback_factor
    if amount <= 1000
      10
    elsif amount <= 1500
      15
    else
      20
    end
  end

  private

  def handle_status
    self.status = retailer.cpf == '15350946056' ? :approved : :validating
  end
end
