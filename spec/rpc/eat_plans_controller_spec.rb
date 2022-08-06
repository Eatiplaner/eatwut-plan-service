# frozen_string_literal: true

require 'rails_helper'

describe EatPlansController do
  it 'binds the service correctly' do
    expect(grpc_bound_service).to eq ::Plan::EatPlanService::Service
  end

  describe '#create_eat_plan' do
    let!(:categories) { create_list(:category, 2) }

    let(:expected_attributes) do
      %i[
        id
        name
        status
        description
        duration_metric
        duration_value
        meals_per_day
        user_id
        categories
        created_at
        updated_at
      ]
    end

    context 'with valid params' do
      it 'create plan successfully' do
        run_rpc(:CreateEatPlan, {
          category_ids: [categories.first.id, categories.second.id],
          name: "detox plan",
          description: "detox",
          duration_metric: "week",
          duration_value: 5,
          meals_per_day: 3,
          user_id: "2"
        }) do |resp|
          expect(resp).to be_a_successful_rpc

          expect(resp.data.categories.count).to eq(2)
          expect(resp.data.to_h.keys).to include(*expected_attributes)

          expect(EatPlan.count).to eq(1)
        end
      end
    end

    context 'with invalid params' do
      it 'create plan unsuccessfully' do
        expect do
          run_rpc(:CreateEatPlan, {
            category_ids: [categories.first.id, categories.second.id],
            name: "detox plan",
            description: "detox",
            duration_metric: "week",
            duration_value: -1,
            meals_per_day: 3,
            user_id: "2"
          })
        end.to raise_rpc_error(GRPC::InvalidArgument)
      end
    end
  end
end
