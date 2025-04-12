# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MenuItemMenu do
  describe 'associations' do
    it { is_expected.to belong_to(:menu_item) }
    it { is_expected.to belong_to(:menu) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price) }
  end
end
