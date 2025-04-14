# frozen_string_literal: true

json.array! @restaurants do |restaurant|
  json.id restaurant.id
  json.name restaurant.name
  json.menus restaurant.menus do |menu|
    json.id menu.id
    json.name menu.name
    json.menu_items menu.menu_items do |menu_item|
      json.id menu_item.id
      json.name menu_item.name
      json.price menu_item.price
    end
  end
end
