# frozen_string_literal: true

class EatPlan < ApplicationRecord
  ################################ ASSOCIATIONS ################################
  has_many :eat_plan_categories, dependent: :destroy
  has_many :categories, through: :eat_plan_categories

  ################################## SETTINGS ##################################
  include GeneratableProtoData

  enum(
    status: {
      draft: 'draft',
      published: 'published',
    }.freeze,
    _prefix: true,
  )

  enum(
    duration_metric: {
      day: 'day',
      week: 'week',
      month: 'month',
    }.freeze,
    _prefix: true,
  )

  ################################# VALIDATIONS ################################
  validates :name, :user_id, presence: true
  validates :name, uniqueness: { scope: :user_id }

  validates :duration_value, :meals_per_day, numericality: { greater_than: 0 }, allow_nil: true
end
