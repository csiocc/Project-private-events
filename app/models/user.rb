class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # event creator relationship
  has_many :created_events, class_name: "Event", foreign_key: :creator_id, inverse_of: :creator, dependent: :destroy
  has_many :invites, through: :events

  # jointable for guests
  has_many :event_guests, inverse_of: :user, dependent: :destroy

  # is guest of a event
  has_many :upcomming_events, through: :event_guests, soure: :event

  # posts and comments relationship
  has_many :posts, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy

  # validations
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

end
