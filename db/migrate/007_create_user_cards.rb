class CreateUserCards < ActiveRecord::Migration[6.0]
  def change
    create_table :user_cards do |t|
      t.integer :user_game_id
      t.integer :card_id
    end
  end
end
