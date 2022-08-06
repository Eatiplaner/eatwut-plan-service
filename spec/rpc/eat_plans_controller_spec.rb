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
      it 'raise invalid argument error' do
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

  describe '#publish_eat_plan' do
    let!(:eat_plan) { create(:eat_plan, :publishable, status:) }
    let(:status)  { EatPlan.statuses[:draft] }

    context 'with eat plan not found' do
      it 'raise not found error' do
        expect do
          run_rpc(:PublishEatPlan, {
            id: 100
          })
        end.to raise_rpc_error(GRPC::NotFound)
      end
    end

    context 'with eat plan already publish' do
      let(:status) { EatPlan.statuses[:published] }

      it 'raise not implemented error' do
        expect do
          run_rpc(:PublishEatPlan, {
            id: eat_plan.id
          })
        end.to raise_rpc_error(GRPC::FailedPrecondition)
      end
    end

    context 'with eat plan status is draft' do
      it 'update status successfully' do
        run_rpc(:PublishEatPlan, {
          id: eat_plan.id
        }) do |resp|
          expect(resp).to be_a_successful_rpc
          expect(eat_plan.reload.status).to eq(EatPlan.statuses[:published])
        end
      end
    end
  end

  describe '#draft_eat_plan' do
    let!(:eat_plan) { create(:eat_plan, :publishable, status:) }
    let(:status)  { EatPlan.statuses[:published] }

    context 'with eat plan not found' do
      it 'raise not found error' do
        expect do
          run_rpc(:DraftEatPlan, {
            id: 100
          })
        end.to raise_rpc_error(GRPC::NotFound)
      end
    end

    context 'with eat plan already draft' do
      let(:status) { EatPlan.statuses[:draft] }

      it 'raise not implemented error' do
        expect do
          run_rpc(:DraftEatPlan, {
            id: eat_plan.id
          })
        end.to raise_rpc_error(GRPC::FailedPrecondition)
      end
    end

    context 'with eat plan status is published' do
      it 'update status successfully' do
        run_rpc(:DraftEatPlan, {
          id: eat_plan.id
        }) do |resp|
          expect(resp).to be_a_successful_rpc
          expect(eat_plan.reload.status).to eq(EatPlan.statuses[:draft])
        end
      end
    end
  end
end
