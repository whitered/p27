module GamesHelper

  def participation_link game, user
    if user && user.is_insider_of?(game.group)
      if game.players.include? user
        link_to t('games.game.leave'), leave_game_path(game), :method => :post
      else
        link_to t('games.game.join'), join_game_path(game), :method => :post
      end
    end
  end

  def currency_select_options
    {
      :collection => Money::Currency::SORTED,
      :label_method => lambda { |currency| t(currency[:iso_code].downcase, :scope => :currency, :default => currency[:name]) },
      :value_method => lambda { |currency| currency[:iso_code] }
    }
  end

end
