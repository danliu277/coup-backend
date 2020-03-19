class CreateGameMoves < ActiveRecord::Migration[6.0]
  def change
    create_table :game_moves do |t|
      t.integer :action
      t.integer :target_id
      t.integer :game_id
      t.integer :user_game_id
      t.integer :reactions, array: true, default: []

      t.timestamps
    end
  end
end
