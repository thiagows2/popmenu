# frozen_string_literal: true

json.array! @restaurants do |restaurant|
  json.id restaurant.id
  json.name restaurant.name

  json.menus restaurant.menus do |menu|
    json.id menu.id
    json.name menu.name

    json.menu_items menu.menu_item_menus do |join_record|
      json.id join_record.menu_item.id
      json.name join_record.menu_item.name
      json.price join_record.price
    end
  end
end
