class CreateUserGames < ActiveRecord::Migration[6.0]
  def change
    create_table :user_games do |t|
      t.integer :money, default: 2
      # t.string :cards, array: true, default: []
      t.integer :user_id
      t.integer :game_id

      t.timestamps
    end
  end
end
