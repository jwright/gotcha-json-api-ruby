require "rails_helper"

RSpec.describe AvatarUploader do
  let(:player) { create :player }

  subject { described_class.new(player, :avatar) }

  after { subject.remove! }

  describe "#extension_whitelist" do
    it "only allows image formats" do
      expect(subject.extension_whitelist).to include *%w(jpg jpeg gif png tiff)
    end

    it "does not allow text files" do
      expect { subject.store! file_fixture("test_text.txt").open }.to \
        raise_error CarrierWave::IntegrityError
    end
  end

  describe "#size_range" do
    it "allows an size range from 0 to 2 megabytes" do
      expect(subject.size_range).to eq 1..2.megabyte
    end
  end

  describe "#store_dir" do
    it "includes the model id for a unique container" do
      expect(subject.store_dir).to eq "uploads/player/avatar/#{player.id}"
    end
  end
end
