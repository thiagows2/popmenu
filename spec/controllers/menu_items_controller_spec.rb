# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MenuItemsController do
  before { create(:menu_item) }

  describe 'GET /index' do
    it 'returns http success' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end
  end
end
