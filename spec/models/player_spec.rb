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

  describe ".with_api_key" do
    subject { create :player, :authorized }

    it "returns the player with the specified api key" do
      expect(described_class.with_api_key(subject.api_key)).to eq subject
    end

    it "returns nil if the player is not found" do
      expect(described_class.with_api_key("blah")).to be_nil
    end

    it "returns nil if the api key is blank" do
      subject.update_attributes api_key: nil

      expect(described_class.with_api_key(nil)).to be_nil
    end
  end

  describe "validations" do
    subject { build :player }

    it "requires a name to be present" do
      subject.name = nil

      expect(subject).to_not be_valid
      expect(subject.errors[:name]).to include "can't be blank"
    end

    it "requires an email address to be present" do
      subject.email_address = nil

      expect(subject).to_not be_valid
      expect(subject.errors[:email_address]).to include "can't be blank"
    end

    it "requires an email address to be a valid email format" do
      subject.email_address = "@test.com"

      expect(subject).to_not be_valid
      expect(subject.errors[:email_address]).to include "is invalid"
    end

    it "requires the email address to be unique" do
      create :player, email_address: subject.email_address

      expect(subject).to_not be_valid
      expect(subject.errors[:email_address]).to include "has already been registered"
    end

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
