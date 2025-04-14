# frozen_string_literal: true

module Imports
  class RestaurantImporter < Base
    def initialize(input)
      @input = input
      @symbolized_data = {}
      @successes = []
      @errors = []
    end

    def call
      validate_input
      symbolize_input
      import_restaurants
      success_result
    rescue StandardError => e
      handle_unexpected_error(e)
      error_result
    end

    private

    attr_reader :input, :symbolized_data, :successes, :errors

    def validate_input
      raise ArgumentError, 'Input is required and cannot be blank' if input.blank?
    end

    def symbolize_input
      @symbolized_data = JsonSymbolizer.call(input)
    end

    def import_restaurants
      return if (restaurants_array = symbolized_data[:restaurants]).blank?

      restaurants_array.each do |restaurant_attrs|
        safely_import { import_restaurant(restaurant_attrs) }
      end
    end

    def import_restaurant(attrs)
      restaurant = import(Restaurant, attrs.slice(:name), find_by: [:name])
      return if restaurant.blank?
      return if (menus_array = attrs[:menus]).blank?

      import_menus(menus_array, restaurant)
    end

    def import_menus(menus_array, restaurant)
      menus_array.each do |menu_attrs|
        safely_import { import_menu(menu_attrs, restaurant) }
      end
    end

    def import_menu(attrs, restaurant)
      menu_attrs = attrs.slice(:name).merge(restaurant_id: restaurant.id)
      menu = import(Menu, menu_attrs, find_by: %i[name restaurant_id])
      return if menu.blank?
      return if (menu_items_array = attrs[:menu_items] || attrs[:dishes]).blank?

      import_menu_items(menu_items_array, menu)
    end

    def import_menu_items(menu_items_array, menu)
      menu_items_array.each do |item_attrs|
        safely_import { import_menu_item(item_attrs, menu) }
      end
    end

    def import_menu_item(attrs, menu)
      safely_save(MenuItemMenu) do
        menu_item = MenuItem.find_or_create_by!(name: attrs[:name])
        menu_item_menu = MenuItemMenu.find_or_initialize_by(menu:, menu_item:)
        assign_menu_item_price(menu_item_menu, attrs[:price])
        log_menu_item_operation(menu_item, menu, menu_item_menu)
        menu_item_menu.save!
      end
    end

    def assign_menu_item_price(menu_item_menu, price)
      return if price.blank?
      return if price.negative?
      return if price == menu_item_menu.price

      menu_item_menu.price = price.to_f
    end

    def log_menu_item_operation(menu_item, menu, menu_item_menu)
      if menu_item_menu.new_record?
        successes << "Created MenuItem ##{menu_item.id} (#{menu_item.name}) for Menu ##{menu.id} " \
          "(#{menu.name}) with price $#{menu_item_menu.price}"
      elsif menu_item_menu.price_changed?
        successes << "Updated MenuItem ##{menu_item.id} (#{menu_item.name}) price from " \
          "$#{menu_item_menu.price_was} to $#{menu_item_menu.price}"
      end
    end
  end
end
