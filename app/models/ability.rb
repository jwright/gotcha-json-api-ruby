class Ability
  include CanCan::Ability

  def initialize(player)
    if player.present?
      can :manage, Match do |match|
        match.arena && match.arena.playable_by?(player)
      end
    end
  end
end
