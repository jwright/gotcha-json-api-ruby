require "fast_jsonapi"

class ScoreSerializer
  include FastJsonapi::ObjectSerializer

  set_type :score
  attributes :points, :scored_at
  belongs_to :arena
  belongs_to :player

  def initialize(resource, options={})
    super

    if @record
      @record = ScoreDecorator.new(@record)
    else
      @records = @records.map { |record| ScoreDecorator.new(record) }
    end
  end

  private

  class ScoreDecorator < SimpleDelegator
    def score_at
      __getobj__.scored_at.to_i
    end
  end
end
