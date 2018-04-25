require "rails_helper"

RSpec.describe Match do
  let(:player) { create :player }

  describe "#closed?" do
    it "is not closed when it is active" do
      active = build :match

      expect(active).to_not be_closed
    end

    it "is closed when it is found" do
      found = build :match, :found

      expect(found).to be_closed
    end

    it "is closed when it is ignored" do
      ignored = build :match, :ignored

      expect(ignored).to be_closed
    end

    it "is closed when it is pending" do
      pending = build :match, :pending

      expect(pending).to be_closed
    end
  end

  describe ".for" do
    let!(:active) { create :match, seeker: player }
    let!(:found) { create :match, :found, opponent: player }

    it "returns all matches for the specified player" do
      expect(described_class.for(player)).to match_array [active, found]
    end
  end

  describe ".found" do
    let!(:found) { create :match, :found, opponent: player }

    it "returns all matches that were found" do
      expect(described_class.found).to match_array [found]
    end
  end

  describe "#found!" do
    subject { create :match }

    it "sets the found_at timestamp" do
      subject.found!

      expect(subject.found_at).to be_within(1.second).of(DateTime.now)
    end

    it "updates the record" do
      subject.found!

      expect(subject).to_not be_changed
    end
  end

  describe "#found?" do
    it "returns true if the found_at timestamp is set" do
      subject = build :match, :found

      expect(subject).to be_found
    end

    it "returns false if the found_at timestamp is not set" do
      subject = build :match

      expect(subject).to_not be_found
    end
  end

  describe ".ignored" do
    let!(:ignored) { create :match, :ignored }

    it "returns all matches that were ignored" do
      expect(described_class.ignored).to match_array [ignored]
    end
  end

  describe "#ignored?" do
    it "returns true if the ignored_at timestamp is set" do
      subject = build :match, :ignored

      expect(subject).to be_ignored
    end

    it "returns false if the ignored_at timestamp is not set" do
      subject = build :match

      expect(subject).to_not be_ignored
    end
  end

  describe ".in" do
    let(:arena_one) { create :arena }
    let(:arena_two) { create :arena }
    let!(:match_one) { create :match, arena: arena_one }
    let!(:match_two) { create :match, arena: arena_two }

    it "returns all the matches that are assigned to the specified arena" do
      result = described_class.in(arena_one)

      expect(result).to match_array [match_one]
    end

    it "does not include matches that are not assigned to the specified arena" do
      result = described_class.in(arena_two)

      expect(result).to match_array [match_two]
    end
  end

  describe ".open" do
    let!(:active) { create :match, seeker: player }
    let!(:found) { create :match, :found, opponent: player }
    let!(:ignored) { create :match, :ignored }

    it "returns all matches that were not found or ignored" do
      expect(described_class.open).to match_array [active]
    end
  end

  describe "#opponent_for" do
    let(:opponent) { create :player }
    let(:seeker) { create :player }
    let(:someone) { create :player }

    subject { create :match, seeker: seeker, opponent: opponent }

    it "returns the seeker if the opponent is passed in" do
      expect(subject.opponent_for(opponent)).to eq seeker
    end

    it "returns the opponent if the seeker is passed in" do
      expect(subject.opponent_for(seeker)).to eq opponent
    end

    it "returns nil if the player is not part of the match" do
      expect(subject.opponent_for(someone)).to be_nil
    end
  end

  describe "#pending?" do
    it "returns true if the pending_at timestamp is set" do
      subject = build :match, :pending

      expect(subject).to be_pending
    end

    it "returns false if the pending_at timestamp is not set" do
      subject = build :match

      expect(subject).to_not be_pending
    end
  end

  describe "#pending!" do
    subject { create :match }

    it "sets the pending_at timestamp" do
      subject.pending!

      expect(subject.pending_at).to be_within(1.second).of(DateTime.now)
    end

    it "updates the record" do
      subject.pending!

      expect(subject).to_not be_changed
    end
  end

  describe "validations" do
    subject { build :match }

    it "requires a timestamp for matched_at" do
      subject.matched_at = nil

      expect(subject).to_not be_valid
      expect(subject.errors[:matched_at]).to include "can't be blank"
    end

    it "does not allow a seeker and an opponent to be the same player" do
      subject.seeker_id = subject.opponent_id

      expect(subject).to_not be_valid
      expect(subject.errors[:seeker]).to \
        include "cannot be in a match with themselves"
    end

    it "does not allow a closed match to be modified" do
      subject.ignored_at = DateTime.now
      subject.found_at = DateTime.now

      expect(subject).to_not be_valid
      expect(subject.errors[:base]).to include "Match is not open"
    end
  end
end
