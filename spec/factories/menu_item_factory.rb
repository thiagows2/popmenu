# frozen_string_literal: true

FactoryBot.define do
  factory :menu_item do
    menu

    name { Faker::Food.dish }
    price { Faker::Commerce.price(range: 5..50) }
  end
end
