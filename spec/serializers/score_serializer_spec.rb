require "rails_helper"

RSpec.describe ScoreSerializer do
  let(:score) { create :score }

  subject { described_class.new(score) }

  describe "#serializable_hash" do
    let(:hash) { subject.serializable_hash[:data] }

    it "serializes the type" do
      expect(hash[:type]).to eq :score
    end

    it "serializes the id" do
      expect(hash[:id]).to eq score.id.to_s
    end

    it "serializes the attributes" do
      expect(hash[:attributes].keys).to \
        match_array [:points, :scored_at]
    end

    it "returns the datetimes in unix Epoch time" do
      expect(hash[:attributes][:scored_at]).to be_a Integer
      expect(Time.at(hash[:attributes][:scored_at])).to \
        be_within(1.second).of(Time.now)
    end

    it "serializes the relationships" do
      expect(hash[:relationships].keys).to \
        match_array [:arena, :player]
      expect(hash[:relationships][:arena][:data][:id]).to \
        eq score.arena_id.to_s
      expect(hash[:relationships][:player][:data][:id]).to \
        eq score.player_id.to_s
    end
  end
end
