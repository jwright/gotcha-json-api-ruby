require "rails_helper"

RSpec.describe Arena do
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
end
