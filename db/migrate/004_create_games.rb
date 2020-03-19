class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :room_id
      t.boolean :started, default: false
      t.integer :user_game_id
      t.integer :winner_id

      t.timestamps
    end
  end
end
