# frozen_string_literal: true

module JsonHelper
  def json_response
    JSON.parse(response.body)
  end
end
