class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         # добавили tracable и confirmable, первый отслеживает даты и кол-во визитов, второй требует подтверждение
         # при регитсрации черз почту.
         # инструкция в WIKI для devise
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  rolify # Модель попадает в распределение ролей. Gem Rolify(прописывается само)

  has_many :courses # Юзер может иметь несколько Курсов
  has_many :enrollments

  # Проверяем, чтобы при редактировании у пользователя была хотябы одна роль
  validate :must_have_a_role, on: :update

  # Расширяем наш класс дополнением для отображения дружественных ссылок
  extend FriendlyId
  friendly_id :email, use: :slugged


  def to_s # Метод для конвертации в строку полейБ возвращенных из БД (массивом)
    email
  end


  def username # Метод обрезает email до собакиБ чтобы сделать из него логин для отображения в карточке
    self.email.split(/@/).first
  end


  # После создания пользователя, назначаем ему роль поумолчанию
  after_create :assign_default_role

  def assign_default_role
    # Если пользователь создал приложение = первым зарегестрировался, то он становится 777
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:student)
      self.add_role(:teacher)
    else
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher)
    end
  end

  # Проверяем он-лайн ли еще пользователь
  def online?
    updated_at > 5.minutes.ago
  end

  # Покупка курса = создаем запись в которую передаем Id курса и цену
  def buy_course(course)
    self.enrollments.create(course: course, price: course.price)
  end

  private

  def must_have_a_role
    unless roles.any?
      errors.add(:roles, 'must have at least one role')
    end
  end


end
