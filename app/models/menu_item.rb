# frozen_string_literal: true

class MenuItem < ApplicationRecord
  belongs_to :menu

  validates :name, presence: true
  validates :price, presence: true, numericality: true
end
