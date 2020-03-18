# frozen_string_literal: true

class RetailerSerializer < ActiveModel::Serializer
  attributes :full_name, :cpf, :email
end
