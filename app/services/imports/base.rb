# frozen_string_literal: true

module Imports
  class Base < ApplicationService
    protected

    attr_reader :successes, :errors

    def result(success:)
      {
        success:,
        successes:,
        errors:,
        summary: {
          successes: successes.size,
          errors: errors.size,
          total: successes.size + errors.size
        }
      }
    end

    def success_result
      result(success: successes.any? || errors.empty?)
    end

    def error_result
      result(success: false)
    end

    def safely_import
      yield
    rescue StandardError => e
      handle_unexpected_error(e)
    end

    def safely_save(model)
      yield
    rescue ActiveRecord::RecordInvalid => e
      errors << "Failed to save #{model.name}: #{e.record.errors.full_messages.join(', ')}"
    rescue StandardError => e
      errors << "Error saving #{model.name}: #{e.message}"
    end

    def import(model, attributes, find_by:)
      record = find_or_initialize_record(model, attributes, find_by)

      safely_save(model) do
        identifiers = find_by.map { |key| "#{key}: #{record[key]}" }.join(', ')
        save_record(record, identifiers) if record.new_record? || record.changed?
      end

      record
    end

    private

    def find_or_initialize_record(model, attributes, find_by)
      find_attributes = attributes.slice(*find_by)
      model.find_or_initialize_by(find_attributes) do |record|
        record.assign_attributes(attributes)
      end
    end

    def save_record(record, identifiers)
      is_new = record.new_record?
      record.save!
      action = is_new ? 'Created' : 'Updated'
      successes << "#{action} #{record.class.name} ##{record.id} with #{identifiers}"
    end

    def handle_unexpected_error(exception)
      Rails.logger.error exception.message
      Rails.logger.error exception.backtrace.join("\n")
      errors << exception.message
    end
  end
end
