# frozen_string_literal: true

class MenuItemsController < ApplicationController
  def index
    @menu_items = MenuItem.includes(:menu_item_menus, menus: :restaurant)
  end
end
