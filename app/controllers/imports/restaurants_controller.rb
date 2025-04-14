# frozen_string_literal: true

module Imports
  class RestaurantsController < ApplicationController
    def create
      result = Imports::RestaurantImporter.call(restaurants_params)
      http_status = result[:success] ? :ok : :unprocessable_entity

      render json: result, status: http_status
    end

    private

    def restaurants_params
      params.permit(
        restaurants: [
          :name,
          { menus: [
            :name,
            { menu_items: %i[name price], dishes: %i[name price] }
          ] }
        ]
      ).to_h
    end
  end
end
