# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Menu do
  describe 'associations' do
    it { is_expected.to have_many(:menu_item_menus).dependent(:destroy) }
    it { is_expected.to have_many(:menu_items).through(:menu_item_menus) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
