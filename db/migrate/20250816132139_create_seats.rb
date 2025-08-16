class CreateSeats < ActiveRecord::Migration[8.0]
  def change
    create_table :seats do |t|
      t.references :seating_table, null: false, foreign_key: true
      t.references :participant, null: true, foreign_key: true

      t.timestamps
    end
  end
end
