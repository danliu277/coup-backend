class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :room_id
      t.boolean :started, default: false
      t.string :deck, array: true, default: []
      t.string :discard, array: true, default: []

      t.timestamps
    end
  end
end
