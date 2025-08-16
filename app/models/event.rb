class Event < ApplicationRecord
  belongs_to :user

  has_many :participants, dependent: :destroy
  has_many :seating_tables, dependent: :destroy

  validates :title, presence: true
  validates :date, presence: true
end
