class Event < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: :creator_id, inverse_of: :created_events
  belongs_to :invite, inverse_of: :event, dependent: :destroy

  #jointable for guests
  has_many :event_guests, through: :invites, source: :event_guests, dependent: :destroy
  # guests of the event
  has_many :guests, through: :event_guests, source: :user

  # event type
  enum :event_type, { catsitting: 0, dogsitting: 1, party: 2, dating: 3 }

  # validations
  validates :title, :date, :description, :location, :event_type, presence: true

end
