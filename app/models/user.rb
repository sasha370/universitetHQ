class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2, :github, :facebook]

  include PublicActivity::Model
  tracked only: [:create, :destroy], owner: :itself
  rolify

  has_many :courses, dependent: :nullify
  has_many :enrollments, dependent: :nullify
  has_many :user_lessons, dependent: :nullify
  has_many :comments, dependent: :nullify

  validate :must_have_a_role, on: :update
  after_create :assign_default_role
  after_create do
    # UserMailer.new_user(self).deliver_later
  end

  extend FriendlyId
  friendly_id :email, use: :slugged

  def to_s
    email
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
      user = User.create(
        email: data['email'],
        name: access_token.info.name,
        image: access_token.info.image,
        provider: access_token.provider,
        uid: access_token.uid,
        token: access_token.credentials.token,
        expires_at: access_token.credentials.expires_at,
        expires: access_token.credentials.expires,
        refresh_token: access_token.credentials.refresh_token,
        password: Devise.friendly_token[0,20],
        confirmed_at: Time.now #autoconfirm user from omniauth
      )
    else #if user account exists - add additional data
    user.name = access_token.info.name
    user.image = access_token.info.image
    user.provider = access_token.provider
    user.uid = access_token.uid
    user.token = access_token.credentials.token
    user.expires_at = access_token.credentials.expires_at
    user.expires = access_token.credentials.expires
    user.refresh_token = access_token.credentials.refresh_token
    user.save!
    end
    user
  end

  def username
    self.email.split(/@/).first
  end

  def assign_default_role
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:student)
      self.add_role(:teacher)
    else
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher)
    end
  end

  def online?
    updated_at > 5.minutes.ago
  end

  def buy_course(course)
    self.enrollments.create(course: course, price: course.price)
  end

  def view_lesson(lesson)
    user_lesson = self.user_lessons.where(lesson: lesson)
    if user_lesson.any?
      user_lesson.first.increment!(:impressions)
    else
      self.user_lessons.create(lesson: lesson)
    end
  end

  def calculate_balance
    update_column :course_income, (courses.pluck(:income).sum)
    update_column :balance, (course_income - enrollment_expences)
  end

  def calculate_enrollment_expences
    update_column :enrollment_expences, (enrollments.pluck(:price).sum)
    update_column :balance, (course_income - enrollment_expences)
  end

  private

  def must_have_a_role
    unless roles.any?
      errors.add(:roles, 'must have at least one role')
    end
  end

end
