class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.references :tournament, foreign_key: true
      t.integer :n_players, null: false, default: 0
      t.integer :round
      t.integer :pyramidal_position
      t.date :date
      t.string :location
      t.boolean :validated, null: false, default: false

      t.timestamps
    end
  end
end
