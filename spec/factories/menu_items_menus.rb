# frozen_string_literal: true

FactoryBot.define do
  factory :menu_item_menu do
    association :menu
    association :menu_item

    price { Faker::Commerce.price(range: 5..50) }
  end
end
