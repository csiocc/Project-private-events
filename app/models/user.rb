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

  # images
  
  has_many_attached :photos

  serialize :image_order, coder: JSON

  def ordered_photos
    return photos unless image_order.present?

    ordered_ids = image_order.map(&:to_i)
    sorted = photos.sort_by { |p| ordered_ids.index(p.id) || photos.size }
    sorted.compact
  end

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

      results = Geocoder.search(location)
      result = results.first

      if results.empty? || result.nil?
        errors.add(:location, "existiert nicht oder konnte nicht gefunden werden")
        throw(:abort)
      else
        self.latitude  = result.latitude
        self.longitude = result.longitude
      end
    end


end
