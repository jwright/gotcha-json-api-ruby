require "rails_helper"

RSpec.describe DeviceSerializer do
  let(:device) { create :device }

  subject { described_class.new(device) }

  describe "#serializable_hash" do
    let(:hash) { subject.serializable_hash[:data] }

    it "serializes the type" do
      expect(hash[:type]).to eq :device
    end

    it "serializes the id" do
      expect(hash[:id]).to eq device.id.to_s
    end

    it "serializes the attributes" do
      expect(hash[:attributes].keys).to \
        match_array [:registered_at, :token]
      expect(hash[:attributes][:token]).to eq device.token
    end

    it "returns the datetimes in unix Epoch time" do
      expect(hash[:attributes][:registered_at]).to be_a Integer
      expect(Time.at(hash[:attributes][:registered_at])).to \
        be_within(1.second).of(Time.now)
    end

    it "serializes the relationships" do
      expect(hash[:relationships].keys).to match_array [:player]
      expect(hash[:relationships][:player][:data][:id]).to \
        eq device.player_id.to_s
    end
  end
end
