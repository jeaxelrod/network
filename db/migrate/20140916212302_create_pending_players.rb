class CreatePendingPlayers < ActiveRecord::Migration
  def change
    create_table :pending_players do |t|
      t.boolean :game_requested, :default => false
      t.integer :game_id

      t.timestamps
    end
  end
end
