require "rails_helper"

RSpec.describe Device do
  describe "validations" do
    subject { build :device }

    it "requires a token to be present" do
      subject.token = nil

      expect(subject).to_not be_valid
      expect(subject.errors[:token]).to include "can't be blank"
    end

    it "requires the token to be unique" do
      create :device, token: subject.token

      expect(subject).to_not be_valid
      expect(subject.errors[:token]).to include "has already been registered"
    end
  end
end
