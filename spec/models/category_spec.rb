require 'rails_helper'

RSpec.describe Category do
  describe 'associations' do
    it {
      is_expected.to have_many(:subcategories).class_name('Category').dependent(:destroy).inverse_of(:parent_category)
    }
    it { is_expected.to belong_to(:parent_category).class_name('Category').optional(true) }
  end

  describe 'settings' do
    it 'has a valid json config file' do
      json_data = File.read(Rails.root.join('lib/tasks/data/category_data.json'))
      expect { JSON.parse(json_data) }.not_to raise_error
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'methods' do
    describe 'subcategory_of?' do
      let(:category) { create(:category) }
      let(:subcategory) { create(:category, parent_category: category) }

      context 'when comparing with not exist category' do
        it 'returns false' do
          expect(subcategory).not_to be_subcategory_of(nil)
        end
      end

      context 'when two category have not relationship' do
        let(:other_category) { create(:category) }

        it 'returns false' do
          expect(subcategory).not_to be_subcategory_of(other_category)
        end
      end

      context 'when two category have relationship' do
        it 'returns false' do
          expect(subcategory).to be_subcategory_of(category)
        end
      end
    end
  end
end
