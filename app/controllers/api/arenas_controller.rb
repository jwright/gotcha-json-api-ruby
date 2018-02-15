class API::ArenasController < ApplicationController
  before_action :require_authorization

  def index
    arenas = Arena.near([params[:latitude], params[:longitude]], 5)
    render json: ArenaSerializer.new(arenas).serialized_json
  end
end
