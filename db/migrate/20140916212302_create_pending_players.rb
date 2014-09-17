class CreatePendingPlayers < ActiveRecord::Migration
  def change
    create_table :pending_players do |t|
      t.boolean :game_played, :default => false

      t.timestamps
    end
  end
end
