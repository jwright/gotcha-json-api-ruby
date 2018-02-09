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
end
