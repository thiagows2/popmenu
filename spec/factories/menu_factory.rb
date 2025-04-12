# frozen_string_literal: true

FactoryBot.define do
  factory :menu do
    name { Faker::Food.dish }

    trait :with_items do
      transient do
        items_count { 3 }
      end

      after(:create) do |menu, evaluator|
        create_list(:menu_item, evaluator.items_count, menu:)
      end
    end
  end
end
