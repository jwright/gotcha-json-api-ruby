require "rails_helper"

RSpec.describe Player do
  include ImageHelper

  describe ".authenticate" do
    let(:password) { "p@ssword" }

    subject { create :player, password: password }

    context "with the correct email and password" do
      it "returns the player" do
        expect(described_class.authenticate(subject.email_address, password)).to \
          eq subject
      end
    end

    context "with an incorrect email address" do
      it "returns nil" do
        expect(described_class.authenticate("blah", password)).to be_nil
      end
    end

    context "with an incorrect password" do
      it "returns nil" do
        expect(described_class.authenticate(subject.email_address, "blah")).to be_nil
      end
    end
  end

  describe "#avatar=" do
    let(:avatar) { file_fixture("led_zeppelin.jpg") }
    let(:base64_avatar) { base64_encode avatar }

    subject { build :player }

    after { subject.remove_avatar! }

    it "attaches the image" do
      subject.avatar = base64_avatar
      subject.save

      expect(subject.avatar.identifier).to eq "avatar.jpeg"
    end
  end

  describe "#generate_api_key!" do
    let(:current_api_key) { "API_KEY" }

    subject { build :player, api_key: current_api_key }

    it "generates a new api key" do
      subject.generate_api_key!

      expect(subject.api_key).to_not eq current_api_key
    end

    it "optionally does not generate a new one if it's not nil" do
      subject.generate_api_key! false

      expect(subject.api_key).to eq current_api_key
    end

    it "generates a new one if it's nil" do
      subject.api_key = nil

      subject.generate_api_key! false

      expect(subject.api_key).to_not be_nil
    end
  end

  describe ".in" do
    let(:arena_one) { create :arena }
    let(:arena_two) { create :arena }
    let!(:player_one) { create :player, arenas: [arena_one, arena_two] }
    let!(:player_two) { create :player, arenas: [arena_one] }

    it "returns all the players who are assigned to the specified arena" do
      result = described_class.in(arena_one)

      expect(result).to match_array [player_one, player_two]
    end

    it "does not include players who are not assigned to the specified arena" do
      result = described_class.in(arena_two)

      expect(result).to match_array [player_one]
    end
  end

  describe "#matched_in?" do
    let(:arena) { create :arena }
    subject { create :player, arenas: [arena] }

    it "returns true if the player is a seeker in a match in the arena" do
      create :match, seeker: subject, arena: arena

      expect(subject).to be_matched_in arena
    end

    it "returns true if the player is an opponent in a match in the arena" do
      create :match, opponent: subject, arena: arena

      expect(subject).to be_matched_in arena
    end

    it "returns false if the player is a seeker in a match in another arena" do
      create :match, opponent: subject

      expect(subject).to_not be_matched_in arena
    end
  end

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

  context "with players in matches" do
    let(:arena) { create :arena }
    let!(:another_arena_match) do
      create :match, seeker: seeker, opponent: opponent
    end
    let!(:found_match) do
      create :match, :found, arena: arena, seeker: seeker, opponent: found_player
    end
    let(:found_player) { create :player, name: "Found", arenas: [arena] }
    let!(:ignored_match) do
      create :match, :ignored, arena: arena, seeker: seeker, opponent: ignored_player
    end
    let(:ignored_player) { create :player, name: "Ignored", arenas: [arena] }
    let!(:open_match) { create :match, arena: arena, opponent: opponent, seeker: seeker }
    let(:opponent) { create :player, name: "Opponent", arenas: [arena] }
    let(:seeker) { create :player, name: "Seeker", arenas: [arena] }
    let!(:unmatched_player) { create :player, name: "Unmatched", arenas: [arena] }

    describe ".already_matched_with" do
      it "returns players that were already in matches together" do
        expect(described_class.already_matched_with(seeker, arena)).to \
          match_array [found_player, ignored_player, opponent]
      end
    end

    describe ".not_already_matched_with" do
      it "does not return players that were already in matches together" do
        expect(described_class.not_already_matched_with(seeker, arena)).to \
          match_array [unmatched_player]
      end
    end

    describe ".unmatched" do
      it "returns players that are not in matches, already found, or ignored" do
        expect(described_class.unmatched).to \
          match_array [unmatched_player, found_player, ignored_player]
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

  describe ".with_email_address" do
    subject { create :player }

    it "returns the player with the specified email address" do
      expect(described_class.with_email_address(subject.email_address.upcase)).to \
        eq subject
    end

    it "returns nil if the player is not found" do
      expect(described_class.with_email_address("blah")).to be_nil
    end

    it "returns nil if the email address is nil" do
      expect(described_class.with_email_address(nil)).to be_nil
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
      subject.password = ""

      expect(subject).to_not be_valid
      expect(subject.errors[:password]).to include "can't be blank"
    end
  end
end
