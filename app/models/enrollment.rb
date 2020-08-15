class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user
  validates :user, :course, presence: true

  # чтобы не было двойной подписки
  validates_uniqueness_of :user_id, scope: :course_id # у учащегося должен быть только один user привязанный к course
  validates_uniqueness_of :course_id, scope: :user_id # у учащегося должен быть только один course привязанный к  user

  validate :cant_subscribe_to_own_course # user не может подписаться на свой собственнй курс


  # Расширяем наш класс дополнением для отображения дружественных ссылок
  extend FriendlyId
  friendly_id :to_s, use: :slugged


  def to_s
    user.to_s + ' ' + course.to_s
  end

  protected

  def cant_subscribe_to_own_course
    if self.new_record?
      if self.user_id.present?
        if self.user_id == course.user_id
          errors.add(:base, "You can not subscribe to your own course")
        end
      end
    end
  end
end
