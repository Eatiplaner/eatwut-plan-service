# frozen_string_literal: true

class EatPlan < ApplicationRecord
  ################################ ASSOCIATIONS ################################
  has_many :eat_plan_categories, dependent: :destroy
  has_many :categories, through: :eat_plan_categories

  ################################## SETTINGS ##################################
  include AASM

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

  MAX_DESCRIPTION = 500
  MAX_NAME = 250

  ################################# STATE MACHINE ################################
  aasm(:status, column: 'status', enum: true) do
    state :draft, initial: true
    state :published

    event :publish, guard: :can_publish? do
      transitions from: :draft, to: :published
    end

    event :draft do
      transitions from: :published, to: :draft
    end
  end

  ################################# VALIDATIONS ################################
  validates :name, :user_id, presence: true
  validates :name, uniqueness: { scope: :user_id }

  validates :name, length: { maximum: MAX_NAME }
  validates :description, length: { maximum: MAX_DESCRIPTION }

  validates :duration_value, :meals_per_day, numericality: { greater_than: 0 }, allow_nil: true

  ################################# METHODS ################################
  def can_publish?
    attributes.values.all?(&:present?) && !categories.empty?
  end
end
