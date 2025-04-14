# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JsonSymbolizer do
  subject(:symbolizer) { described_class.new(data) }

  describe '#call' do
    context 'when input is a File' do
      let(:data) { File.open(Rails.root.join('spec/fixtures/restaurants.json')) }
      let(:expected_result) do
        { restaurants: [
          {
            menus: [
              {
                menu_items: [
                  { name: 'Burger', price: 9.0 },
                  { name: 'Small Salad', price: 5.0 }
                ],
                name: 'lunch'
              },
              {
                menu_items: [
                  { name: 'Burger', price: 15.0 },
                  { name: 'Large Salad', price: 8.0 }
                ],
                name: 'dinner'
              }
            ],
            name: "Poppo's Cafe"
          },
          {
            menus: [
              {
                dishes: [
                  { name: 'Chicken Wings', price: 9.0 },
                  { name: 'Burger', price: 9.0 },
                  { name: 'Chicken Wings', price: 9.0 }
                ],
                name: 'lunch'
              },
              {
                dishes: [
                  { name: 'Mega "Burger"', price: 22.0 },
                  { name: 'Lobster Mac & Cheese', price: 31.0 }
                ],
                name: 'dinner'
              }
            ],
            name: 'Casa del Poppo'
          }
        ] }
      end

      it 'parses and symbolizes the file contents' do
        expect(symbolizer.call).to eq(expected_result)
      end
    end

    context 'when input is a String' do
      let(:data) { '{"first_key": "value", "nested": {"second_key": "value2"}}' }

      it 'parses and symbolizes the JSON string' do
        expect(symbolizer.call).to eq({ first_key: 'value', nested: { second_key: 'value2' } })
      end
    end

    context 'when input is a Hash' do
      let(:data) { { 'first_key' => 'value', 'nested' => { 'second_key' => 'value2' } } }

      it 'symbolizes the hash keys' do
        expect(symbolizer.call).to eq({ first_key: 'value', nested: { second_key: 'value2' } })
      end
    end

    context 'when input is a HashWithIndifferentAccess' do
      let(:data) { ActiveSupport::HashWithIndifferentAccess.new('first_key' => 'value') }

      it 'symbolizes the hash keys' do
        expect(symbolizer.call).to eq({ first_key: 'value' })
      end
    end

    context 'when JSON is invalid' do
      let(:data) { '{invalid_json: "data"' }

      it 'raises an ArgumentError' do
        expect { symbolizer.call }.to raise_error(ArgumentError, /Invalid JSON format/)
      end
    end

    context 'when input type is not supported' do
      let(:data) { 42 }

      it 'raises an ArgumentError' do
        expect { symbolizer.call }.to raise_error(ArgumentError, /Cannot symbolize data of type Integer/)
      end
    end
  end
end
