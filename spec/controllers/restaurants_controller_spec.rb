# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestaurantsController do
  describe 'GET /index' do
    it 'returns http success' do
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end
  end
end
