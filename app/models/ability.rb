class Ability
  include CanCan::Ability

  def initialize(player)
    if player.present?
      can :read, Arena do |arena|
        arena.playable_by?(player)
      end

      can [:create, :read, :update], Match do |match|
        match.arena && match.arena.playable_by?(player)
      end
    end
  end
end
