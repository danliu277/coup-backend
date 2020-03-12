class CreateUserGames < ActiveRecord::Migration[6.0]
  def change
    create_table :user_games do |t|
      t.integer :money
      t.string :cards, array: true

      t.timestamps
    end
  end
end
