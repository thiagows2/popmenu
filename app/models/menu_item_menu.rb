# frozen_string_literal: true

class MenuItemMenu < ApplicationRecord
  self.table_name = 'menu_items_menus'

  belongs_to :menu
  belongs_to :menu_item

  validates :price, presence: true, numericality: { greater_than: 0 }
end
