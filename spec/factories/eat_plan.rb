# frozen_string_literal: true

FactoryBot.define do
  factory :eat_plan do
    name { FFaker::Name.name }
    status { 'draft' }
    duration_metric { 'week' }
    duration_value { 5 }
    meals_per_day { 3 }
  end
end
