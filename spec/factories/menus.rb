# frozen_string_literal: true

FactoryBot.define do
  factory :menu do
    association :restaurant

    name { Faker::Food.dish }
  end
end
