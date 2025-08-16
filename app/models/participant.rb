class Participant < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true
  has_one :seat, dependent: :nullify # If participant is deleted, free up the seat

  validates :email, presence: true, uniqueness: { scope: :event_id }

  before_validation :associate_user, on: :create
  before_validation :set_name_from_user, on: :create

  private

  def associate_user
    self.user = User.find_by(email: email)
  end

  def set_name_from_user
    if user
      self.name = user.name
    else
      # If there is no user, we can't get a name.
      # The name field should probably be nullable or removed.
      # For now, let's use the email as the name.
      self.name = email.split('@').first if name.blank?
    end
  end
end
