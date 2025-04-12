# frozen_string_literal: true

class MenusController < ApplicationController
  def index
    @menus = Menu.includes(:restaurant, menu_item_menus: :menu_item)
  end
end
