class Enrollment < ApplicationRecord
  belongs_to :course
  belongs_to :user
  validates :user, :course, presence: true


  # Рейтинг или отзыв не могут быть оставленны отдельно друг от друга
  validates_presence_of :rating, if: :review?
  validates_presence_of :review, if: :rating?


  # чтобы не было двойной подписки
  validates_uniqueness_of :user_id, scope: :course_id # у учащегося должен быть только один user привязанный к course
  validates_uniqueness_of :course_id, scope: :user_id # у учащегося должен быть только один course привязанный к  user

  validate :cant_subscribe_to_own_course # user не может подписаться на свой собственнй курс


  # Расширяем наш класс дополнением для отображения дружественных ссылок
  extend FriendlyId
  friendly_id :to_s, use: :slugged

  # Область поиска для проверки наличия отзыва или рейтинга
  scope :pending_review, -> { where(rating: [0, nil, ""], review: [0, nil, ""]) }

  def to_s
    user.to_s + ' ' + course.to_s
  end

  # После сохранения, нужно обновить рейтинг
  after_save do
    # Чтобы не обращатся к БД каждый раз когда рейтинга нет или поставлен 0
    unless rating.nil? || rating.zero?
      course.update_rating
    end
  end

  # После удаления, обновтьи рейтинг
  after_destroy do
    course.update_rating
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
