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
  has_many :upcomming_events, through: :event_guests, source: :event

  # posts and comments relationship
  has_many :posts, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy

  # validations
  geocoded_by :location
  validate :location_must_exist
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :profile_text, length: { maximum: 1000 }
  validates :gender, inclusion: { in: %w[male female other], allow_blank: true }
  validates :show_gender_preferences, inclusion: { in: %w[men women both], allow_blank: true }
  
  private

    def location_must_exist
      return if location.blank?

      result = Geocoder.search(location).first

      if result.nil?
        errors.add(:location, "existiert nicht oder konnte nicht gefunden werden")
      else
        self.latitude  = result.latitude
        self.longitude = result.longitude
      end
    end
end
