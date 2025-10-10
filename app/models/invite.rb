class Invite < ApplicationRecord
  belongs_to :event
  belongs_to :user

  has_many :event_guests, dependent: :destroy

  # validations
  validates :event_id, presence: true
  validates :user_id, presence: true
end
