# frozen_string_literal: true

class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.includes(menus: { menu_item_menus: :menu_item })
  end
end
