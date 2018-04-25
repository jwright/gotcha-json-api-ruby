require "rails_helper"

RSpec.describe SuccessfulCaptureJob do
  let(:arena) { create :arena }
  let(:match) do
    create :match, :found, arena: arena, seeker: seeker, opponent: opponent
  end
  let(:opponent) { create :player, name: "Robert Plant", arenas: [arena] }
  let(:seeker) { create :player, name: "Jimmy Page", arenas: [arena] }

  before do
    allow_any_instance_of(SuccessfulCaptureNotifier).to receive(:notify!)
  end

  it "does not process if the match no longer exists" do
    match_id = match.id

    match.destroy

    expect { described_class.perform_now match_id }.to_not raise_error
  end

  it "does not process if it is not a found match" do
    match.found_at = nil
    match.ignored!

    expect { described_class.perform_now match.id }.to_not \
      change { Score.count }
  end

  it "notifies the players of a successful capture" do
    expect(SuccessfulCaptureNotifier).to \
      receive(:new).with(match).and_call_original
    expect_any_instance_of(SuccessfulCaptureNotifier).to receive(:notify!)

    described_class.perform_now match.id
  end

  it "scores the match for the players" do
    expect { described_class.perform_now match.id }.to \
      change { Score.count }.by(2)
  end
end
