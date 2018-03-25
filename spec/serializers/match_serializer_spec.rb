require "rails_helper"

RSpec.describe MatchSerializer do
  let(:match) { create :match }

  subject { described_class.new(match) }

  describe "#serializable_hash" do
    let(:hash) { subject.serializable_hash[:data] }

    it "serializes the type" do
      expect(hash[:type]).to eq :match
    end

    it "serializes the id" do
      expect(hash[:id]).to eq match.id.to_s
    end

    it "serializes the attributes" do
      expect(hash[:attributes].keys).to \
        match_array [:found_at, :matched_at]
    end

    it "serializes the relationships" do
      expect(hash[:relationships].keys).to \
        match_array [:arena, :seeker, :opponent]
      expect(hash[:relationships][:arena][:data][:id]).to \
        eq match.arena_id.to_s
      expect(hash[:relationships][:seeker][:data][:id]).to \
        eq match.seeker_id.to_s
      expect(hash[:relationships][:opponent][:data][:id]).to \
        eq match.opponent_id.to_s
    end
  end
end
