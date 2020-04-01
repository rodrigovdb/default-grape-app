# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email     do Faker::Internet.unique.free_email end
    password  do Faker::Internet.username end
  end
end
