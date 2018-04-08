require "fast_jsonapi"

class MatchSerializer
  include FastJsonapi::ObjectSerializer

  set_type :match
  attributes :found_at, :matched_at
  belongs_to :arena
  belongs_to :opponent
  belongs_to :seeker

  def initialize(resource, options={})
    super

    if @record
      @record = MatchDecorator.new(@record)
    else
      @records = @records.map { |record| MatchDecorator.new(record) }
    end
  end

  private

  class MatchDecorator < SimpleDelegator
    def found_at
      __getobj__.found_at.to_i unless __getobj__.found_at.nil?
    end

    def matched_at
      __getobj__.matched_at.to_i
    end
  end
end
