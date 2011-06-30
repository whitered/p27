class AddCurrencyToGame < ActiveRecord::Migration
  def self.up
    add_column :games, :currency, :string
    rename_column :games, :buyin, :buyin_cents
    rename_column :games, :addon, :addon_cents
    rename_column :games, :rebuy, :rebuy_cents
  end

  def self.down
    rename_column :games, :rebuy_cents, :rebuy
    rename_column :games, :addon_cents, :addon
    rename_column :games, :buyin_cents, :buyin
    remove_column :games, :currency
  end
end
