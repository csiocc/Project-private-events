class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # event creator relationship
  has_many :created_events, class_name: "Event", foreign_key: :creator_id, inverse_of: :creator, dependent: :destroy
  has_many :invites

  # jointable for guests
  has_many :event_guests, inverse_of: :user, dependent: :destroy

  # is guest of a event
  has_many :upcomming_events, through: :event_guests, source: :event

  # posts and comments relationship
  has_many :posts, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy

  #user relationships
  has_many :active_follows, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: :followed_id, dependent: :destroy

  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  #Dating
  has_many :likes_given, class_name: "Like", foreign_key: "liker_id", dependent: :destroy
  has_many :likes_received, class_name: "Like", foreign_key: "liked_id", dependent: :destroy
  has_many :liked_users, through: :likes_given, source: :liked
  has_many :likers, through: :likes_received, source: :liker

  # is user x following me?
  def following?(other_user)
    following.include?(other_user)
  end
  # follow user x
  def follow(other_user)
    active_follows.create(followed: other_user) unless self == other_user || following?(other_user)
  end
  #stop following user x
  def unfollow(other_user)
    active_follows.find_by(followed: other_user)&.destroy
  end

  # images
  has_many_attached :photos

  serialize :image_order, coder: JSON

  # order images
  def ordered_photos
    return photos unless image_order.present?

    ordered_ids = image_order.map(&:to_i)
    sorted = photos.sort_by { |p| ordered_ids.index(p.id) || photos.size }
    sorted.compact
  end

  # Einladungen empfangen
  def received_invites
    invites.includes(:event)
  end

  # Einladungen versendet (als Event-Ersteller)
  def sent_invites
    Invite.where(event_id: created_events.pluck(:id))
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
