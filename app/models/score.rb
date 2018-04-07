class Score < ApplicationRecord
  belongs_to :arena
  belongs_to :player

  validates :scored_at, presence: true

  def self.captured_player!(arena, player)
    self.create! arena: arena, player: player, scored_at: DateTime.now, points: 1
  end
end
