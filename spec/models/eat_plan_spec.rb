require 'rails_helper'

RSpec.describe EatPlan do
  describe 'associations' do
    it { is_expected.to have_many(:eat_plan_categories).dependent(:destroy) }
    it { is_expected.to have_many(:categories).through(:eat_plan_categories) }
  end

  describe 'settings' do
    it do
      values = {
        draft: 'draft',
        published: 'published',
      }

      expect(subject).to define_enum_for(:status).with_values(values).backed_by_column_of_type(:string).with_prefix
    end

    it do
      values = {
        day: 'day',
        week: 'week',
        month: 'month',
      }

      expect(subject).to define_enum_for(:duration_metric).with_values(values)\
        .backed_by_column_of_type(:string).with_prefix
    end
  end

  describe 'validations' do
    let(:eat_plan) { build(:eat_plan, user_id: 2) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:user_id) }

    it { is_expected.to validate_length_of(:name).is_at_most(250) }
    it { is_expected.to validate_length_of(:description).is_at_most(500) }

    it { expect(eat_plan).to validate_uniqueness_of(:name).scoped_to(:user_id) }

    describe 'duration_value' do
      it { is_expected.not_to allow_value(-1).for(:duration_value) }
      it { is_expected.not_to allow_value(0).for(:duration_value) }
      it { is_expected.to allow_value(5).for(:duration_value) }
      it { is_expected.to allow_value(nil).for(:duration_value) }
    end

    describe 'meals_per_day' do
      it { is_expected.not_to allow_value(-1).for(:meals_per_day) }
      it { is_expected.not_to allow_value(0).for(:meals_per_day) }
      it { is_expected.to allow_value(3).for(:meals_per_day) }
      it { is_expected.to allow_value(nil).for(:meals_per_day) }
    end
  end

  describe 'state_machine' do
    let(:eat_plan) { create(:eat_plan, :publishable, status:) }

    describe 'publish' do
      subject { eat_plan.publish! }

      let(:status) { described_class.statuses[:draft] }

      context 'with status is published' do
        let(:status) { described_class.statuses[:published] }

        it 'raise invalid transition' do
          expect { subject }.to raise_error AASM::InvalidTransition
        end
      end

      context 'with status is draft' do
        context 'when not fill all information' do
          before do
            eat_plan.duration_value = nil
          end

          it 'raise invalid transition' do
            expect { subject }.to raise_error AASM::InvalidTransition
          end
        end

        context 'valid data' do
          it 'change status successfully' do
            expect(subject).to be_truthy
            expect(eat_plan.reload.status).to eq(described_class.statuses[:published])
          end
        end
      end
    end

    describe 'draft' do
      subject { eat_plan.draft! }

      let(:status) { described_class.statuses[:active] }

      context 'with status is draft' do
        let(:status) { described_class.statuses[:draft] }

        it 'raise invalid transition' do
          expect { subject }.to raise_error AASM::InvalidTransition
        end
      end

      context 'with status is published' do
        let(:status) { described_class.statuses[:published] }

        it { expect(subject).to be_truthy }
      end
    end
  end
end
