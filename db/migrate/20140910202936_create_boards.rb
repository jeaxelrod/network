class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.text :white
      t.text :black
      t.string :game_type

      t.timestamps
    end
  end
end
