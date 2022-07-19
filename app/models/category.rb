# frozen_string_literal: true

class Category < ApplicationRecord
  ################################ ASSOCIATIONS ################################
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_category_id',
                           dependent: :destroy, inverse_of: :parent_category
  belongs_to :parent_category, class_name: 'Category', optional: true

  ################################## SETTINGS ##################################
  accepts_nested_attributes_for :subcategories

  ################################# VALIDATIONS ################################
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  ################################### METHODS ##################################
  def subcategory_of?(category)
    return false unless category

    parent_category == category
  end
end
