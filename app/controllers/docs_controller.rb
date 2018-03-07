class DocsController < ActionController::Base
  def index
    respond_to do |format|
      format.json {
        render json: Swagger::Blocks.build_root_json([ApplicationController])
      }
      format.html {
        render layout: false
      }
    end
  end
end
