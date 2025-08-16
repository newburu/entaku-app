class User < ApplicationRecord
  has_secure_password

  enum role: { organizer: 0, attendee: 1 }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true

  has_many :events, dependent: :destroy
  has_many :event_participations, class_name: "Participant", dependent: :destroy
end
