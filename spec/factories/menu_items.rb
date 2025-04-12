# frozen_string_literal: true

FactoryBot.define do
  factory :menu_item do
    name { Faker::Food.unique.dish }

    after(:create) do |menu_item|
      create(:menu_item_menu, menu_item:)
    end
  end
end
