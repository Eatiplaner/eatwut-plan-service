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
    it { is_expected.to validate_presence_of(:name) }

    describe 'duration_value' do
      it { is_expected.not_to allow_value(-1).for(:duration_value) }
      it { is_expected.not_to allow_value(0).for(:duration_value) }
      it { is_expected.to allow_value(5).for(:duration_value) }
    end

    describe 'meals_per_day' do
      it { is_expected.not_to allow_value(-1).for(:meals_per_day) }
      it { is_expected.not_to allow_value(0).for(:meals_per_day) }
      it { is_expected.to allow_value(3).for(:meals_per_day) }
    end
  end
end
