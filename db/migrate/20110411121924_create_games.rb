class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.references :announcer
      t.references :group
      t.text :description
      t.string :place
      t.datetime :date

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
