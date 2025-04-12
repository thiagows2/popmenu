# frozen_string_literal: true

class Restaurant < ApplicationRecord
  has_many :menus, dependent: :destroy

  validates :name, presence: true
end
