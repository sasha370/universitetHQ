class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         # добавили tracable и confirmable, первый отслеживает даты и кол-во визитов, второй требует подтверждение
         # при регитсрации черз почту.
         # инструкция в WIKI для devise
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  rolify # Модель попадает в распределение ролей. Gem Rolify(прописывается само)

  has_many :courses, dependent: :nullify # При удалении юзера, обнуляем его связанные курсы
  has_many :enrollments, dependent: :nullify # При удалении юзера, обнуляем его связанные курсы
  has_many :user_lessons, dependent: :nullify # При удалении юзера, обнуляем его связанные курсы
  has_many :comments, dependent: :nullify # коменты удаляются.обнуляются вместе с Пользователем


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

  # Метод создает запись о просмотренном уроке 
  def view_lesson(lesson)
    user_lesson = self.user_lessons.where(lesson: lesson)
    # Но перед созданием проверяем, нет ли уже существующей записи
    if user_lesson.any?
      # если запись ест, то увеличиваем счетчик просмотров на 1
      user_lesson.first.increment!(:impressions)
    else
      # если записи нет, то создаем новую
      self.user_lessons.create(lesson: lesson)
    end
  end


  private

  def must_have_a_role
    unless roles.any?
      errors.add(:roles, 'must have at least one role')
    end
  end


end
