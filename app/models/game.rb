class Game < ApplicationRecord
  validates :in_progress, inclusion: { in: [true, false] }
  validates :needs_a_player, inclusion: { in: [true, false] }

  belongs_to :winner, class_name: "Player", optional: true
  has_many :players
  has_many :rounds
  has_many :users, through: :players

  #needs test
  def self.start_new(user)
    game = Game.create()
    Player.create(game: game, user: user)
    return game
  end

  #needs test
  def add_player_and_start(user)
    if self.players.count == 1
      if self.players.first.user == user
        error_message = "You can't play a game against yourself"
      else
        Player.create(game: self, user: user)
        self.update(needs_a_player: false, in_progress: true)
        self.players.sample.update(is_dealer: true)
        Round.start(self)
      end
    else
      error_message = "Error: This game has #{self.players.count} players, needs 2 players to start"
    end
  end

  #returns true if already ended, ends game, sets winner, and returns true if a player has 61 points, otherwise returns false
  def game_over?
    if !in_progress
      return true
    elsif players.first.score == 61
      self.update(winner: players.first, in_progress: false)
      return true
    elsif players.second.score == 61
      self.update(winner: players.second, in_progress: false)
      return true
    else
      return false
    end
  end

end
