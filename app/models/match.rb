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
  scope :open, -> { where(found_at: nil, ignored_at: nil, pending_at: nil) }

  validates :matched_at, presence: true
  validate :pending_match_requires_confirmation_code
  validate :active_match_requires_absent_confirmation_code
  validate :closed_match_status_cannot_be_updated
  validate :seeker_cannot_be_opponent

  def closed?
    found? || ignored? || pending?
  end

  def found!(confirmation_code)
    if (!confirmation_code.to_s.blank? &&
        confirmation_code.to_s == self.confirmation_code.to_s)
      update_attributes! pending_at: nil,
                         found_at: DateTime.now
    end
  end

  def found?
    found_at.present?
  end

  def ignored!
    update_attributes! pending_at: nil,
                       confirmation_code: nil,
                       ignored_at: DateTime.now
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

  def pending!
    update_attributes! confirmation_code: TokenGenerator.generate_code(4),
                       pending_at: DateTime.now
  end

  def pending?
    pending_at.present?
  end

  private

  def active_match_requires_absent_confirmation_code
    if (!confirmation_code.blank? && (open? || ignored?))
      status = ignored? ? "ignored" : "open"
      errors.add(:confirmation_code, "must be blank for #{status} matches")
    end
  end

  def closed_match_status_cannot_be_updated
    if (pending? || found?) && ignored?
      errors.add(:base, "Match is not open")
    end
  end

  def pending_match_requires_confirmation_code
    if (pending? && confirmation_code.blank?)
      errors.add(:confirmation_code, "can't be blank for pending matches")
    end
  end

  def seeker_cannot_be_opponent
    if seeker_id.to_i == opponent_id.to_i
      errors.add(:seeker, "cannot be in a match with themselves")
    end
  end
end
