class Event < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: :creator_id, inverse_of: :created_events

  has_many :invites, dependent: :destroy

  # event type
  enum :event_type, { catsitting: 0, dogsitting: 1, party: 2, dating: 3 }

  # validations
  validates :title, :date, :description, :location, :event_type, presence: true

end
