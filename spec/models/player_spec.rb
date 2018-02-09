require "rails_helper"

RSpec.describe Player do
  describe "#password" do
    subject { build :player }

    context "before saving" do
      it "generates an encrypted password" do
        subject.save

        expect(subject.crypted_password).to_not be_blank
        expect(subject.salt).to_not be_blank
      end

      it "clears the virtual password field" do
        subject.save

        expect(subject.password).to be_nil
      end
    end
  end

  describe "validations" do
    it "requires a password on creation" do
      subject.password = nil

      expect(subject).to_not be_valid
      expect(subject.errors[:password]).to include "can't be blank"
    end

    it "requires a password on update when changing" do
      subject = create :player
      subject.password = nil

      expect(subject).to_not be_valid
      expect(subject.errors[:password]).to include "can't be blank"
    end
  end
end
