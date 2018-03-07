require_relative "../documentation/root"

class ApplicationController < ActionController::API
  include Documentation::Root

  attr_reader :current_user

  before_action :verify_content_type_header,
                :verify_accept_header,
                :set_current_user

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render_errors exception.record.errors.full_messages, :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    exception = "#{exception.model} with #{exception.primary_key} "\
                "#{exception.id} not found"
    render_errors exception, :not_found
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render_errors exception.message
  end

  rescue_from JSONAPI::NotAcceptableError do |exception|
    render_errors exception.message, :not_acceptable
  end

  rescue_from JSONAPI::UnauthorizedError do |exception|
    render_errors exception.message, :unauthorized
  end

  rescue_from JSONAPI::UnsupportedMediaTypeError do |exception|
    render_errors exception.message, :unsupported_media_type
  end

  protected

  def render_errors(messages, status=:bad_request)
    errors = [messages].flatten

    render json: { errors: errors }, status: status
  end

  def require_authorization
    raise JSONAPI::UnauthorizedError if current_user.nil?
  end

  def set_current_user
    if request.headers["Authorization"].present?
      if token = request.headers["Authorization"].split(" ").last
        @current_user = Player.with_api_key(token)
      end
    end
  end

  def verify_accept_header
    unless request.accept == JSONAPI::MEDIA_TYPE ||
           request.accept.start_with?("*/*")
      raise JSONAPI::NotAcceptableError.new(request.accept)
    end
  end

  def verify_content_type_header
    # This is needed because Rails returns a :bad_request (400) instead
    # of a :unsupported_media_type (415) for invalid content-type headers
    # There is a PR to fix this: https://github.com/rails/rails/pull/26632
    if request.post? || request.put? || request.patch?
      unless request.content_type == JSONAPI::MEDIA_TYPE
        raise JSONAPI::UnsupportedMediaTypeError.new(request.content_type)
      end
    end
  end
end
