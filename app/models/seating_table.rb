class SeatingTable < ApplicationRecord
  belongs_to :event
  has_many :seats, dependent: :destroy

  validates :name, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :x_position, presence: true, numericality: { only_integer: true }
  validates :y_position, presence: true, numericality: { only_integer: true }

  after_create :create_seats_for_table

  private

  def create_seats_for_table
    capacity.times do
      seats.create!
    end
  end
end
