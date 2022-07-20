class CategoriesController < Gruf::Controllers::Base
  bind Plan::CategoryService::Service

  def get_categories
    parent_categories = Category
      .includes(:subcategories)
      .where(parent_category_id: nil)

    Plan::GetCategoriesResp.new(
      data: parent_categories.map do |parent|
        generate_parent_category(parent)
      end
    )
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  private

  def generate_parent_category(category)
    Plan::ParentCategory.new(
      id: category.id,
      name: category.name,
      subcategories: category.subcategories.map do |sub|
        generate_sub_category(sub)
      end
    )
  end

  def generate_sub_category(category)
    Plan::SubCategory.new(
      id: category.id,
      name: category.name,
    )
  end
end
