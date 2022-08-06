# frozen_string_literal: true

class EatPlanCategory < ApplicationRecord
  ################################ ASSOCIATIONS ################################
  belongs_to :eat_plan
  belongs_to :category
end
