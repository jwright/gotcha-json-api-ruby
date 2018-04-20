require_relative "../documentation/root"

class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  include Documentation::Root

  attr_reader :current_user

  before_action :verify_content_type_header,
                :verify_accept_header,
                :verify_type_parameter,
                :set_current_user

  rescue_from ActiveRecord::RecordInvalid do |exception|
    render_errors exception.record.errors.full_messages, :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    if exception.model.present?
      exception = "#{exception.model} with #{exception.primary_key} "\
                  "#{exception.id} not found"
    else
      exception = exception.message
    end
    render_errors exception, :not_found
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render_errors exception.message
  end

  rescue_from CanCan::AccessDenied do |exception|
    render_jsonapi_errors \
      JSONAPI::Exceptions::NotAuthorizedError.new(exception.message)
  end

  rescue_from JSONAPI::Exceptions::RuntimeError do |exception|
    render_jsonapi_errors exception
  end

  protected

  def expected_resource_type
    self.class.name
      .demodulize
      .gsub("Controller", "")
      .underscore
      .singularize
  end

  def render_jsonapi_errors(exception)
    render json: { errors: exception.errors }, status: exception.status
  end

  def render_errors(messages, status=:bad_request)
    errors = [messages].flatten

    render json: { errors: errors }, status: status
  end

  def require_authorization
    raise JSONAPI::Exceptions::NotAuthorizedError if current_user.nil?
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
      raise JSONAPI::Exceptions::NotAcceptableError.new(request.accept)
    end
  end

  def verify_content_type_header
    # This is needed because Rails returns a :bad_request (400) instead
    # of a :unsupported_media_type (415) for invalid content-type headers
    # There is a PR to fix this: https://github.com/rails/rails/pull/26632
    if request.post? || request.put? || request.patch? || request.delete?
      unless request.content_type == JSONAPI::MEDIA_TYPE
        raise JSONAPI::Exceptions::UnsupportedMediaTypeError
          .new(request.content_type)
      end
    end
  end

  def verify_type_parameter
    verify_data_type_parameter unless params[:data].nil?
  end

  def verify_data_type_parameter
    raise JSONAPI::Exceptions::MissingTypeParameterError \
      if params[:data][:type].nil?
    raise JSONAPI::Exceptions::TypeMismatchError.new(params[:data][:type]) \
      unless params[:data][:type] == expected_resource_type
  end
end
