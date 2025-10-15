class Post < ApplicationRecord
  belongs_to :user
  has_many :post_likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :root_comments, -> { where(parent_id: nil).order(created_at: :asc) },
           class_name: "Comment"
  validates :title, presence: true
  validates :body, presence: true
end
