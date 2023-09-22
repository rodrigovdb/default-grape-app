# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email     { Faker::Internet.unique.free_email }
    password  { Faker::Internet.username }
  end
end
