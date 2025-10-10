class Event < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: :creator_id, inverse_of: :created_events
  beolngs_to :invite, inverse_of: :event, dependent: :destroy

  #jointable for guests
  has_many :event_guests, through: :invites, source: :event_guests, dependent: :destroy
  # guests of the event
  has_many :guests, through: :event_guests, source: :user  

  # validations
  validates :title, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :date, presence: true
end
