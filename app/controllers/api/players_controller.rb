class API::PlayersController < ApplicationController
  include JSONAPI::ActsAsResourceController

  before_action :require_authorization, except: :create

  private

  def context
    { current_user: current_user }
  end
end
