# frozen_string_literal: true

class JsonSymbolizer < ApplicationService
  def initialize(data)
    @data = data
  end

  def call
    case data
    when File
      parse_json(data.read)
    when String
      parse_json(data)
    when Hash, ActiveSupport::HashWithIndifferentAccess
      data.dup.deep_symbolize_keys
    else
      raise ArgumentError, "Cannot symbolize data of type #{data.class}"
    end
  end

  private

  attr_reader :data

  def parse_json(json)
    JSON.parse(json, symbolize_names: true)
  rescue JSON::ParserError => e
    raise ArgumentError, "Invalid JSON format: #{e.message}"
  end
end
