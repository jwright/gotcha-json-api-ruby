require "rails_helper"

RSpec.describe Arena do
  include GeocodingHelper

  describe "geocoding" do
    let(:latitude) { 39.1234 }
    let(:longitude) { -104.78941 }

    subject { build :arena, latitude: nil, longitude: nil }

    before { stub_geocoding latitude, longitude }

    it "populates the latitude and longitude based on the address" do
      subject.save

      expect(subject.latitude).to eq latitude
      expect(subject.longitude).to eq longitude
    end
  end

  describe "#address" do
    subject do
      build :arena, street_address1: "123 Main St.",
                    street_address2: "Apt. 20",
                    city: "Beverly Hills",
                    state: "CA",
                    zip_code: 90210
    end

    it "returns a string representation of the address components" do
      expect(subject.address).to \
        eq "123 Main St., Apt. 20, Beverly Hills, CA, 90210"
    end

    it "skips the second address field if it is empty" do
      subject.street_address2 = ""

      expect(subject.address).to \
        eq "123 Main St., Beverly Hills, CA, 90210"
    end
  end

  describe "#playable_by?" do
    let(:player) { create :player }
    subject { create :arena }

    it "returns true if the player is playing in the arena" do
      player.arenas << subject

      expect(subject).to be_playable_by player
    end

    it "returns false if the player is not playing in the arena" do
      expect(subject).to_not be_playable_by player
    end
  end
end
