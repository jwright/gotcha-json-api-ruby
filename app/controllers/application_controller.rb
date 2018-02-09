class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do |exception|
    render_errors exception.message
  end

  protected

  def render_errors(messages, status=:bad_request)
    errors = [messages].flatten

    render json: { errors: errors }, status: status
  end
end
