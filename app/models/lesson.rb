class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  validates :title, :content, :course, presence: true
  validates :title, length: {maximum: 70}
  validates_uniqueness_of :title, scope: :course
  has_many :user_lessons, dependent: :destroy
  has_many :comments, dependent: :nullify

  has_rich_text :content

  has_one_attached :video
  has_one_attached :video_thumbnail
  validates :video, content_type: ['video/mp4'],
            size: { less_than: 50.megabytes, message: "image must be less that 50 MB" }
  validates :video_thumbnail,content_type: [:png, :jpg, :jpeg],
            size: { less_than: 500.kilobytes, message: "image must be less that 500 Kb" }

  extend FriendlyId
  friendly_id :title, use: :slugged

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  include RankedModel
  ranks :row_order, :with_same => :course_id


  def to_s
    title
  end

  def prev
    course.lessons.where("row_order < ?", row_order).order(:row_order).last
  end

  def next
    course.lessons.where("row_order > ?", row_order).order(:row_order).first
  end

  def viewed(user)
    self.user_lessons.where(user: user).present?
  end
end
