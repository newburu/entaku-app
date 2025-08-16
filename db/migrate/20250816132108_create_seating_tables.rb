class CreateSeatingTables < ActiveRecord::Migration[8.0]
  def change
    create_table :seating_tables do |t|
      t.string :name
      t.string :shape
      t.integer :x_position
      t.integer :y_position
      t.integer :capacity
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
