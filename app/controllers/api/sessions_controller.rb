class API::SessionsController < ApplicationController
  include JSONAPI::ActsAsResourceController

  before_action :require_authorization, only: :destroy

  def destroy
    current_user.update_attributes! api_key: nil

    results = JSONAPI::OperationResults.new
    results.add_result JSONAPI::OperationResult.new(:no_content)

    render_results results
  end

  private

  def context
    { current_user: current_user }
  end
end
