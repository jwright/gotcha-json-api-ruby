class Match < ApplicationRecord
  belongs_to :seeker, class_name: "Player"
  belongs_to :opponent, class_name: "Player"
  belongs_to :arena

  scope :for, ->(player) do
    where(seeker_id: player).or(where(opponent_id: player))
  end
  scope :found, -> { where.not(found_at: nil) }
  scope :ignored, -> { where.not(ignored_at: nil) }
  scope :in, ->(arena) { where(arena_id: arena) }
  scope :open, -> { where(found_at: nil, ignored_at: nil) }

  validates :matched_at, presence: true

  def opponent_for(player)
    return opponent if player == seeker
    return seeker if player == opponent
  end
end
