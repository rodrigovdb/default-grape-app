# frozen_string_literal: true

class SaleSerializer < ActiveModel::Serializer
  attributes :sale_code, :amount, :sold_at, :cashback_factor, :cashback, :status
end
