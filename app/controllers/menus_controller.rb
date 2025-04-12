# frozen_string_literal: true

class MenusController < ApplicationController
  def index
    render json: Menu.includes(:menu_items)
  end
end
