# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MenusController do
  before { create(:menu) }

  describe 'GET /index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'returns all menus' do
      get :index
      expect(json_response.size).to eq(1)
    end
  end
end
