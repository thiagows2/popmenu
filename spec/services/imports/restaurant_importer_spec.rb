# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Imports::RestaurantImporter do
  subject(:import) { importer.call }

  let(:json_data) { File.read(Rails.root.join('spec/fixtures/restaurants.json')) }
  let(:importer) { described_class.new(json_data) }

  describe '#call' do
    context 'with valid input' do
      it 'returns a successful result' do
        expect(import[:success]).to be true
      end

      it 'imports restaurants' do
        expect { import }.to change(::Restaurant, :count).by(2)
      end

      it 'imports menus' do
        expect { import }.to change(::Menu, :count).by(4)
      end

      it 'imports menu items' do
        expect { import }.to change(::MenuItem, :count).by(6)
      end

      it 'creates menu item menu associations' do
        expect { import }.to change(::MenuItemMenu, :count).by(8)
      end
    end

    context 'with no restaurants data' do
      let(:empty_data) { { other_data: 'something' }.to_json }
      let(:importer) { described_class.new(empty_data) }

      it 'returns a successful result' do
        expect(import[:success]).to be true
      end

      it 'does not create restaurants' do
        expect { import }.not_to change(Restaurant, :count)
      end
    end

    context 'when a menu item with the same name already exists' do
      let(:menu_name) { 'Main Menu' }
      let(:menu_item_name) { 'Burger' }

      let(:json_data) do
        {
          restaurants: [
            {
              name: 'Test Restaurant',
              menus: [
                {
                  name: menu_name,
                  menu_items: [{ name: menu_item_name, price: 8.99 }]
                }
              ]
            }
          ]
        }.to_json
      end

      before do
        create(:menu_item_menu, menu: create(:menu, name: menu_name),
                                menu_item: create(:menu_item, name: menu_item_name),
                                price: 5.99)
      end

      it 'reuses existing items instead of creating duplicates' do
        expect { import }.not_to change(MenuItem.where(name: menu_item_name), :count)
      end

      it 'creates a new item association with menu' do
        expect { import }.to change(MenuItemMenu, :count).by(1)
      end

      it 'creates a new item association with the new price' do
        import
        menu_item = MenuItem.find_by(name: menu_item_name)
        menu_item_menu = MenuItemMenu.where(menu_item:)
        expect(menu_item_menu.map(&:price).map(&:to_f)).to include(8.99)
      end
    end

    context 'when the same menu item appears in multiple menus with different prices' do
      let(:json_data) do
        {
          restaurants: [
            {
              name: 'Test Restaurant',
              menus: [
                {
                  name: 'Lunch Menu',
                  menu_items: [{ name: 'Pasta', price: 9.99 }]
                },
                {
                  name: 'Dinner Menu',
                  menu_items: [{ name: 'Pasta', price: 12.99 }]
                }
              ]
            }
          ]
        }.to_json
      end

      it 'creates one menu item record' do
        expect { import }.to change(MenuItem, :count).by(1)
      end

      it 'creates menu_item_menu associations for each menu' do
        expect { import }.to change(MenuItemMenu, :count).by(2)
      end

      it 'associates the menu item with the correct menus' do
        import
        pasta_item = MenuItem.find_by(name: 'Pasta')
        lunch_menu = Menu.find_by(name: 'Lunch Menu')
        dinner_menu = Menu.find_by(name: 'Dinner Menu')
        expect(pasta_item.menus).to include(lunch_menu, dinner_menu)
      end
    end

    context 'when the price to update is the same as the current one' do
      let(:menu_name) { 'Drink Menu' }
      let(:json_data) do
        {
          restaurants: [
            {
              name: 'Pub',
              menus: [
                {
                  name: menu_name,
                  menu_items: [{ name: 'Soda', price: 3.00 }]
                }
              ]
            }
          ]
        }.to_json
      end

      before do
        create(:menu_item_menu,
               menu: create(:menu, name: menu_name),
               menu_item: create(:menu_item, name: 'Soda'),
               price: 3.00)
      end

      it 'does not track any errors' do
        result = import
        expect(result[:errors]).to be_empty
      end

      it 'completes successfully' do
        result = import
        expect(result[:success]).to be true
      end
    end

    context 'with invalid price in menu_item_menu' do
      let(:json_data) do
        {
          restaurants: [
            {
              name: 'Test Restaurant',
              menus: [
                {
                  name: 'Main Menu',
                  menu_items: [{ name: 'Expensive Item', price: -5.99 }]
                }
              ]
            }
          ]
        }.to_json
      end

      it 'adds error messages when price validation fails' do
        result = import
        expect(result[:errors]).to include(a_string_matching(/Price must be greater than 0/))
      end
    end

    context 'when an unexpected error occurs' do
      let(:error_message) { 'Database connection failure' }

      before do
        allow(importer).to receive(:import_restaurant).and_raise(StandardError.new(error_message))
      end

      it 'returns a failed result' do
        expect(import[:success]).to be false
      end

      it 'includes error messages in the result' do
        expect(import[:errors]).to include(error_message)
      end
    end

    context 'with invalid restaurant data' do
      let(:invalid_data) { { restaurants: [{ name: '' }] }.to_json }
      let(:importer) { described_class.new(invalid_data) }

      it 'returns a failure result' do
        expect(import[:success]).to be false
      end

      it 'captures validation errors' do
        expect(import[:errors]).not_to be_empty
      end
    end

    context 'with malformed JSON input' do
      let(:malformed_json) { '{invalid_json: "data"' }
      let(:importer) { described_class.new(malformed_json) }

      it 'returns a failure result for malformed JSON' do
        expect(import[:success]).to be false
      end

      it 'includes error messages for JSON parsing errors' do
        expect(import[:errors]).not_to be_empty
      end
    end
  end
end
