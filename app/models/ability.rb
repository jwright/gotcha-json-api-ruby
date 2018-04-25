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

      can :manage, Player do |someone_else|
        someone_else == player
      end

      can :read, Player do |someone_else|
        player.matched_with?(someone_else)
      end

      can :read, Score do |score|
        score.arena && score.arena.playable_by?(player)
      end
    end
  end
end
