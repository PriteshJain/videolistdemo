module ApiResponse
  extend ActiveSupport::Concern

  def not_found_json(message:, resource_name: nil, field: 'id')
    errors = []

    if resource_name
      # Resource cannot be found
      errors << build_error(resource_name, field, 'missing')
    end

    error_envelope(message, errors)
  end

  def bad_request_json(message:)
    error_envelope(message, [])
  end

  def internal_server_error_json
    message = 'Oops! Something went wrong!'
    errors  = []

    error_envelope(message, errors)
  end

  def validations_error_json(resource)
    errors = errors_for(resource)
    message = resource.errors.full_messages.first
    error_envelope(message, errors)
  end

  private

  def errors_for(resource)
    resource_errors = resource.errors.details

    resource_errors.map do |field, reasons|
      build_error(resource.class.name.demodulize, field, reasons.map { |r| reason_for(r[:error]) }.first)
    end
  end

  def build_error(resource_name, field, reason)
    { resource: resource_name, field: field, reason: reason }
  end

  def error_envelope(message, errors)
    { message: message, display_message: message, errors: errors }
  end

  def reason_for(error)
    error == :blank ? 'missing_field' : 'invalid'
  end
end