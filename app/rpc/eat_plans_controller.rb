class EatPlansController < Gruf::Controllers::Base
  bind Plan::EatPlanService::Service

  def create_eat_plan
    eat_plan = EatPlan.new(request.message.to_h)

    if eat_plan.save
      Plan::CreateEatPlanResp.new(
        data: generate_plan(eat_plan)
      )
    else
      raise ArgumentError, eat_plan.errors.full_messages
    end
  rescue ArgumentError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:invalid_argument, :invalid_argument, "ERROR: #{e.message}")
  rescue StandardError => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end

  def publish_eat_plan
    eat_plan = find_eat_plan
    eat_plan.publish!

    ::Google::Protobuf::Empty.new
  rescue AASM::InvalidTransition => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:failed_precondition, :failed_precondition, "ERROR: #{e.message}")
  rescue ActiveRecord::RecordNotFound => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:not_found, :not_found, "ERROR: #{e.message}")
  end

  def draft_eat_plan
    eat_plan = find_eat_plan
    eat_plan.draft!

    ::Google::Protobuf::Empty.new
  rescue AASM::InvalidTransition => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:failed_precondition, :failed_precondition, "ERROR: #{e.message}")
  rescue ActiveRecord::RecordNotFound => e
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:not_found, :not_found, "ERROR: #{e.message}")
  end

  private

  def find_eat_plan
    EatPlan.find(request.message[:id])
  end

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
