class Invite < ApplicationRecord
  belongs_to :user

  has_many :event_guests, dependent: :destroy

  # validations
  validates :user_id, presence: true
end
