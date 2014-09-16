class CreatePendingPlayers < ActiveRecord::Migration
  def change
    create_table :pending_players do |t|
      t.string :username

      t.timestamps
    end
  end
end
