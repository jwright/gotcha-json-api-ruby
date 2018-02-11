require "rails_helper"

RSpec.describe PlayerSerializer do
  let(:player) { create :player }

  subject { described_class.new(player) }

  describe "#serializable_hash" do
    let(:hash) { subject.serializable_hash[:data] }

    it "serializes the type" do
      expect(hash[:type]).to eq :player
    end

    it "serializes the id" do
      expect(hash[:id]).to eq player.id.to_s
    end

    it "serializes the attributes" do
      expect(hash[:attributes].keys).to \
        match_array [:api_key, :avatar, :email_address, :name]
      expect(hash[:attributes][:email_address]).to eq player.email_address
    end
  end
end
