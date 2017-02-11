class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :name, null: false
      t.integer :number_players, null: false
      t.string :prize, null: false
      t.integer :entrance_fee, null: false
      t.date :date, null: false
      t.integer :status, null: false, default: 0
      t.integer :match_players, null: false, default: 4
      t.integer :mode, null: false, default: 0
      t.integer :rounds
      t.integer :registered, null: false, default: 0

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
