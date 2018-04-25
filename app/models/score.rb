class Score < ApplicationRecord
  belongs_to :arena
  belongs_to :player

  scope :for, ->(player) { where(player_id: player) }
  scope :in, ->(arena) { where(arena_id: arena) }
  scope :playable_by, ->(player) do
    joins(arena: :player_arenas)
      .where(player_id: player)
      .distinct
  end

  validates :scored_at, presence: true
  validate :player_must_be_in_arena, on: [:create, :update]

  def self.captured_player!(arena, player)
    self.create! arena: arena, player: player, scored_at: DateTime.now, points: 1
  end

  private

  def player_must_be_in_arena
    if arena.present?
      errors.add(:player, "cannot play in arena") unless arena.playable_by?(player)
    end
  end
end
