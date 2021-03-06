class Round < ApplicationRecord
  validates :current_stage, inclusion: { in: ["new", "discard", "play", "count"]}
  validates :count, numericality: true
  validates :in_progress, inclusion: { in: [true, false]} #needs to be added to test

  belongs_to :game
  belongs_to :active_player, class_name: "Player", optional: true
  has_many :players, through: :game
  has_one :deck

  def pone
    players.find_by(is_dealer: false)
  end

  def dealer
    players.find_by(is_dealer: true)
  end

  #returns the player that belongs to the given user
  def player(user)
    players.find_by(user: user)
  end

  #returns the opponent playing against the given user
  def opponent(user)
    players.where.not(user: user).first
  end

  def self.start(game)
    round = Round.create(game: game)
    round.update(active_player: round.pone)
    deck = Deck.create_deck(round)

    4.times do
      deck.draw(round.pone)
      deck.draw(round.dealer)
    end

    round.update(current_stage: "play")
    return round
  end

  def self.delete_round(round)
    round.deck.cards.destroy_all
    round.deck.destroy
    round.players.each do |player|
      player.cards.destroy_all
    end
    round.destroy
  end
end
