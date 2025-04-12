# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MenuItemsController do
  before { create(:menu_item) }

  describe 'GET /index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns all menu items' do
      get :index
      expect(json_response.size).to eq(1)
    end
  end
end
