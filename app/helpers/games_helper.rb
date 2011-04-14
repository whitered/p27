module GamesHelper

  def participation_link game, user
    if user && user.is_insider_of?(game.group)
      if game.users.include? user
        link_to t('games.game.leave'), leave_game_path(game), :method => :post
      else
        link_to t('games.game.join'), join_game_path(game), :method => :post
      end
    end
  end


end
