require "rails_helper"

RSpec.describe MatchSerializer do
  let(:match) { create :match, :found }

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

    it "returns the datetimes in unix Epoch time" do
      expect(hash[:attributes][:found_at]).to be_kind_of(Integer)
      expect(hash[:attributes][:matched_at]).to be_kind_of(Integer)
      expect(Time.at(hash[:attributes][:found_at])).to \
        be_within(1.second).of(Time.now)
      expect(Time.at(hash[:attributes][:matched_at])).to \
        be_within(1.second).of(Time.now)
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
