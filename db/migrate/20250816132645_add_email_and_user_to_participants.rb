class AddEmailAndUserToParticipants < ActiveRecord::Migration[8.0]
  def change
    add_column :participants, :email, :string
    add_reference :participants, :user, null: false, foreign_key: true
  end
end
