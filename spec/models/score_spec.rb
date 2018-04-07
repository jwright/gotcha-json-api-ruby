require "rails_helper"

RSpec.describe Score do
  describe "validations" do
    subject { build :score }

    it "requires a timestamp for scored_at" do
      subject.scored_at = nil

      expect(subject).to_not be_valid
      expect(subject.errors[:scored_at]).to include "can't be blank"
    end
  end
end
