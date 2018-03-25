require "rails_helper"

RSpec.describe MatchNotifier do
  let(:match) { create :match, seeker: seeker, opponent: opponent }
  let(:opponent) { create :player, name: "Robert Plant" }
  let(:seeker) { create :player, name: "Jimmy Page" }
  let!(:seeker_device) { create :device, player: seeker }

  before { allow_any_instance_of(Houston::Client).to receive(:push) }

  describe "#initialize" do
    it "initializes with a match" do
      expect(described_class.new(match).match).to eq match
    end
  end

  describe "#notify_player!" do
    subject { described_class.new(match) }

    it "creates a push notification for the player" do
      expect(Houston::Notification).to \
        receive(:new).with(device: seeker_device.token).and_call_original

      subject.notify_player!(seeker)
    end

    it "tells the player who is looking for them" do
      expect_any_instance_of(Houston::Notification).to \
        receive(:alert=).with("Gotcha! Robert Plant is out to get 'cha!")
        .and_call_original

      subject.notify_player!(seeker)
    end

    it "tells the player how many open matches they have" do
      create :match, opponent: seeker

      expect_any_instance_of(Houston::Notification).to \
        receive(:badge=).with(2).and_call_original

      subject.notify_player!(seeker)
    end

    it "passes on the match data" do
      expect_any_instance_of(Houston::Notification).to \
        receive(:custom_data=).with(MatchSerializer.new(match).serializable_hash)
        .and_call_original

      subject.notify_player!(seeker)
    end

    context "without a device token for the player" do
      it "does not create a push notification for the player" do
        expect(Houston::Notification).to_not receive(:new)

        subject.notify_player!(opponent)
      end
    end
  end

  describe "#notify!" do
    subject { described_class.new(match) }

    it "notifies the seeker and the opponent" do
      expect(subject).to receive(:notify_player!).with(match.seeker).ordered
      expect(subject).to receive(:notify_player!).with(match.opponent).ordered

      subject.notify!
    end
  end
end
