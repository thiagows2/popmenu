# frozen_string_literal: true

class CreateJoinTableMenusMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_join_table :menu_items, :menus do |t|
      t.decimal :price, precision: 8, scale: 2
      t.index %i[menu_item_id menu_id]
      t.timestamps
    end
  end
end
