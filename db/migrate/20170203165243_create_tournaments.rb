class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :number_players
      t.string :prize
      t.integer :entrance_fee
      t.date :date
      t.integer :status
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
