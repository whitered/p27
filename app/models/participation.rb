class Participation < ActiveRecord::Base

  belongs_to :user
  belongs_to :game

  validates_presence_of :game
  validates_uniqueness_of :user_id, :scope => :game_id, :allow_nil => true
  validates_uniqueness_of :dummy_name, :scope => :game_id, :allow_nil => true
  validates_presence_of :dummy_name, :if => 'user_id.nil?'
  validates_inclusion_of :addon, :in => [true, false]

  def rebuys
    self[:rebuys] || 0
  end

  def win
    Money.new(self[:win_cents] || 0, game.currency.try(:to_currency) || Money.default_currency)
  end

  def win= value
    if value.is_a?(Money)
      # ensure that the game uses the same currency
      game_currency = game.currency.try(:to_currency) || Money.default_currency
      raise(ArgumentError, "Could not set win in #{value.currency.to_s} for game with currency #{game_currency.to_s}") if game_currency != value.currency
    else
      # suppose the currency matches the game one
      value = value.to_money(game.try(:currency))
    end
    self[:win_cents] = value.cents
  end

end
