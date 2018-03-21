class Match < ApplicationRecord
  belongs_to :seeker, class_name: "Player"
  belongs_to :opponent, class_name: "Player"
  belongs_to :arena

  scope :found, -> { where.not(found_at: nil) }
  scope :ignored, -> { where.not(ignored_at: nil) }
  scope :open, -> { where(found_at: nil, ignored_at: nil) }
end
