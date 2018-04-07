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
  validate :closed_match_status_cannot_be_updated
  validate :seeker_cannot_be_opponent

  def closed?
    found? || ignored?
  end

  def found!
    update_attributes! found_at: DateTime.now
  end

  def found?
    found_at.present?
  end

  def ignored?
    ignored_at.present?
  end

  def open?
    !closed?
  end

  def opponent_for(player)
    return opponent if player == seeker
    return seeker if player == opponent
  end

  private

  def closed_match_status_cannot_be_updated
    if found? && ignored?
      errors.add(:base, "Match is not open")
    end
  end

  def seeker_cannot_be_opponent
    if seeker_id.to_i == opponent_id.to_i
      errors.add(:seeker, "cannot be in a match with themselves")
    end
  end
end
