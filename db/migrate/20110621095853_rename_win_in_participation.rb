class RenameWinInParticipation < ActiveRecord::Migration
  def self.up
    rename_column :participations, :win, :win_cents
  end

  def self.down
    rename_column :participations, :win_cents, :win
  end
end
