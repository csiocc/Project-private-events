class EventGuest < ApplicationRecord
  belongs_to :event, inverse_of: :event_guests
  belongs_to :user, inverse_of: :event_guests

  #invitation stsatus
  enum rsvp_status: { pending: 0, accepted: 1, declined: 2 }, _default: :pending

  # validations every user can only be guest once per event
  validates :event_id, uniqueness: { scope: :user_id }
end
