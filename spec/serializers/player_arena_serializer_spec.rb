require "rails_helper"

RSpec.describe PlayerArenaSerializer do
  let(:player_arena) { create :player_arena }

  subject { described_class.new(player_arena) }

  describe "#serializable_hash" do
    let(:hash) { subject.serializable_hash[:data] }

    it "serializes the type" do
      expect(hash[:type]).to eq :player_arena
    end

    it "serializes the id" do
      expect(hash[:id]).to eq player_arena.id.to_s
    end

    it "serializes the attributes" do
      expect(hash[:attributes].keys).to match_array [:joined_at]
      expect(hash[:attributes][:joined_at]).to be_a Integer
    end

    it "serializes the relationships" do
      expect(hash[:relationships].keys).to match_array [:arena]
      expect(hash[:relationships][:arena][:data][:id]).to \
        eq player_arena.arena_id.to_s
    end
  end
end
