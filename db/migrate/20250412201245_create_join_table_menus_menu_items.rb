# frozen_string_literal: true

class CreateJoinTableMenusMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items_menus do |t|
      t.references :menu_item, null: false, foreign_key: true
      t.references :menu, null: false, foreign_key: true
      t.decimal :price, precision: 8, scale: 2, null: false, default: 0.0
      t.timestamps
    end

    add_index :menu_items_menus, %i[menu_item_id menu_id], unique: true
  end
end
