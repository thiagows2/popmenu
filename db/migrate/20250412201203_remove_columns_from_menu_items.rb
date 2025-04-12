# frozen_string_literal: true

class RemoveColumnsFromMenuItems < ActiveRecord::Migration[8.0]
  def change
    remove_reference :menu_items, :menu, null: false, foreign_key: true
    remove_column :menu_items, :price, :decimal, precision: 8, scale: 2
  end
end
