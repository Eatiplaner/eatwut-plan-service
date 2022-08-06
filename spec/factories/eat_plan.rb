# frozen_string_literal: true

FactoryBot.define do
  factory :eat_plan do
    name { FFaker::Name.name }
    description { FFaker::Lorem.paragraph(10).truncate(EatPlan::MAX_DESCRIPTION) }
    status { 'draft' }
    duration_metric { 'week' }
    duration_value { 5 }
    meals_per_day { 3 }
    user_id { FFaker::Number.rand(1..10) }
  end

  trait :publishable do
    before(:create) do |record|
      category = create(:category)

      record.update(category_ids: category.id)
    end
  end
end
