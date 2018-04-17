class API::DevicesController < ApplicationController
  include JSONAPI::ActsAsResourceController

  before_action :require_authorization

  private

  def context
    { current_user: current_user }
  end
end
