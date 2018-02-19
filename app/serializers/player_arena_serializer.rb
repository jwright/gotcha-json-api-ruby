require "fast_jsonapi"

class PlayerArenaSerializer
  include FastJsonapi::ObjectSerializer

  set_type :player_arena
  attributes :joined_at
  belongs_to :arena

  def initialize(resource, options={})
    super
    @record = PlayerArenaDecorator.new(@record)
  end

  private

  class PlayerArenaDecorator < SimpleDelegator
    def joined_at
      __getobj__.joined_at.to_i
    end
  end
end
