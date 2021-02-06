class Course < ApplicationRecord
  validates :title, :marketing_description, :description, :language, :level, :price, presence: true
  validates :description, length: {minimum: 5, maximum: 3000}
  validates :marketing_description, length: {minimum: 5, maximum: 300}
  validates :title, uniqueness: true, length: {maximum: 70}
  validates :price, numericality: {greater_than_or_equal_to: 0, less_than: 50000} # цена должна быть Положительной и не более 50 тыс.

  has_rich_text :description

  has_one_attached :avatar
  validates :avatar, presence: true, on: :update
  validates :avatar, content_type: [:png, :jpg, :jpeg],
            size: {less_than: 500.kilobytes, message: "image must be less that 500 Kb"}


  belongs_to :user, counter_cache: true
  has_many :lessons, dependent: :destroy, inverse_of: :course
  accepts_nested_attributes_for :lessons, reject_if: :all_blank, allow_destroy: true
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons
  has_many :course_tags, dependent: :destroy
  has_many :tags, through: :course_tags


  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  scope :latest, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }

  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }
  LANGUAGES = ["English", "Russian", "France", "Spanish"]
  LEVELS = ["Beginner", "Intermediate", "Advance"]

  def to_s
    title
  end

  extend FriendlyId
  friendly_id :title, use: :slugged

  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  def bought(user)
    self.enrollments.where(user_id: user.id, course_id: self.id).empty?
  end

  def progress(user)
    unless self.lessons_count == 0
      user_lessons.where(user: user).count / self.lessons_count.to_f * 100
    end
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0)
    end
  end

  def calculate_income
    update_column :income, (enrollments.pluck(:price).sum)
    user.calculate_balance
  end
  pluck
end
