class Placement
  attr_reader :arena

  def initialize(arena)
    @arena = arena
  end

  def ordinal_for(player)
    place = place_for(player)

    place.nil? ? "-" : place.ordinalize
  end

  def place_for(player)
    # if no one has any scores, then return nil
    return nil if scores.values.all?(&:zero?)

    # if player is not found, return nil
    return nil unless scores.keys.include?(player.id)

    # players with the same score should be in the same place
    score = scores[player.id]
    scores.values.index(score) + 1
  end

  def scores
    @scores ||= retrieve_scores
  end

  private

  def retrieve_scores
    arena_scores = Score.in(arena).all

    arena.players.map { |player| PlacementScore.new(player, arena_scores) }
      .sort
      .inject({}) { |hash, placement| hash.merge(placement.to_h) }
  end

  class PlacementScore
    attr_reader :player, :score

    def initialize(player, scores)
      @player = player
      @score = scores.select { |score| score.player_id == player.id }.sum(&:points)
    end

    def to_h
      { player.id => score }
    end

    def <=>(other)
      other.score <=> self.score
    end
  end
end
