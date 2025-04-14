# frozen_string_literal: true

class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[show menus menu_items]

  def index
    @restaurants = Restaurant.includes(menus: { menu_item_menus: :menu_item })
  end

  def show; end

  def menus
    @menus = @restaurant.menus.includes(menu_item_menus: :menu_item)
    render 'menus/index'
  end

  def menu_items
    @menu_items = MenuItem.joins(menu_item_menus: :menu)
                          .where(menu_item_menus: { menus: { restaurant_id: @restaurant.id } })
                          .distinct
                          .includes(:menu_item_menus, menus: :restaurant)
    render 'menu_items/index'
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
