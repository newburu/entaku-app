class Seat < ApplicationRecord
  belongs_to :seating_table
  belongs_to :participant, optional: true

  validates :participant_id, uniqueness: { scope: :seating_table_id, allow_nil: true }
end
