class PlayerArena < ApplicationRecord
  belongs_to :player
  belongs_to :arena
end
