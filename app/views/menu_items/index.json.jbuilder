# frozen_string_literal: true

json.array! @menu_items do |menu_item|
  json.id menu_item.id
  json.name menu_item.name

  json.menus menu_item.menu_item_menus do |join_record|
    json.menu_id join_record.menu.id
    json.menu_name join_record.menu.name
    json.price join_record.price
    json.restaurant do
      json.id join_record.menu.restaurant.id
      json.name join_record.menu.restaurant.name
    end
  end
end
