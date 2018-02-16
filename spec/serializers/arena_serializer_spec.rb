require "rails_helper"

RSpec.describe ArenaSerializer do
  let(:arena) { create :arena }

  subject { described_class.new(arena) }

  describe "#serializable_hash" do
    let(:hash) { subject.serializable_hash[:data] }

    it "serializes the type" do
      expect(hash[:type]).to eq :arena
    end

    it "serializes the id" do
      expect(hash[:id]).to eq arena.id.to_s
    end

    it "serializes the attributes" do
      expect(hash[:attributes].keys).to \
        match_array [:location_name,
                     :latitude,
                     :longitude,
                     :street_address1,
                     :street_address2,
                     :city,
                     :state,
                     :zip_code]
      expect(hash[:attributes][:location_name]).to eq arena.location_name
    end
  end
end
