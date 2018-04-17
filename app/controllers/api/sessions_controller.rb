class API::SessionsController < ApplicationController
  include JSONAPI::ActsAsResourceController

  before_action :require_authorization, only: :destroy

  def destroy
    current_user.update_attributes! api_key: nil

    head :no_content
  end

  private

  def context
    { current_user: current_user }
  end
end
