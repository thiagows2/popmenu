# frozen_string_literal: true

class MenuItemsController < ApplicationController
  def index
    render json: MenuItem.includes(:menu)
  end
end
