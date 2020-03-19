# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :token

  def id
    object.public_id
  end
end
