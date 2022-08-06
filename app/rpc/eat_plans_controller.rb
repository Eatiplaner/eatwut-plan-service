class EatPlansController < Gruf::Controllers::Base
  bind Plan::EatPlanService::Service

  def create_eat_plan
    eat_plan = EatPlan.new(request.message.to_h)

    if eat_plan.save
      Plan::CreateEatPlanResp.new(
        data: generate_plan(eat_plan)
      )
    else
      raise StandardError, eat_plan.errors.full_messages
    end
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  private

  def generate_plan(eat_plan)
    Plan::EatPlan.new(
      eat_plan.gen_proto_data.merge(
        categories: generate_category(eat_plan)
      )
    )
  end

  def generate_category(eat_plan)
    eat_plan.categories.map do |category|
      Plan::EatPlanCategoryResp.new(
        id: category.id,
        name: category.name
      )
    end
  end
end
