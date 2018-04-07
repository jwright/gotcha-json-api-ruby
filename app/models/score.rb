class Score < ApplicationRecord
  belongs_to :arena
  belongs_to :player

  validates :scored_at, presence: true
end
