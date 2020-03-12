class CreateGameMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :game_moves do |t|
      t.string :action
      t.integer :target_id

      t.timestamps
    end
  end
end
