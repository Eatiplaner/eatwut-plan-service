# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { FFaker::Name.name }

    trait :with_sub_categories do
      after(:create) do |category|
        category.subcategories = FactoryBot.create_list(:product_category, 2)
      end
    end
  end
end
