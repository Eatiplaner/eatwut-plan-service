# frozen_string_literal: true

require 'rails_helper'

describe CategoriesController do
  it 'binds the service correctly' do
    expect(grpc_bound_service).to eq ::Plan::CategoryService::Service
  end

  describe '#get_categories' do
    let!(:categories) { create_list(:category, 2, :with_sub_categories) }

    it 'returns list category' do
      run_rpc(:GetCategories, nil) do |resp|
        expect(resp).to be_a_successful_rpc

        expect(resp.data.first).to be_a(::Plan::ParentCategory)
        expect(resp.data.first.id).to eq categories.first.id
        expect(resp.data.first.name).to eq categories.first.name

        expect(resp.data.first.subcategories.first.id).to eq categories.first.subcategories.first.id
        expect(resp.data.first.subcategories.first.name).to eq categories.first.subcategories.first.name
      end
    end
  end
end
