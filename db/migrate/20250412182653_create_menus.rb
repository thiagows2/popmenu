# frozen_string_literal: true

class CreateMenus < ActiveRecord::Migration[8.0]
  def change
    create_table :menus do |t|
      t.string :name

      t.timestamps
    end
  end
end
