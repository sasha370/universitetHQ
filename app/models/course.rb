class Course < ApplicationRecord
  # Валидация для новых курсов, обязательно присутствие названия и описания не менее 5 символов
  validates :title, :short_description, :language, :level, :price, presence: true
  validates :description, presence: true, length: { minimum: 5 }
  validates :title, uniqueness: true
  # Подключаем встроенный редактор текста для поля вуыскшзешщт
  has_rich_text :description

  # У каждого курса есть прикрепленный файл ( аватар в нашем случае), который будет хранится на S3
  has_one_attached :avatar

  # Курс принадлежит только одному пользователю
  belongs_to :user, counter_cache: true
  # Курс имеет множество уроков, которые удаляются вместе с курсом
  has_many :lessons, dependent: :destroy
  # Отслеживаем любые изменения, которые выдают ошибки ( когда есть зависимости)
  has_many :enrollments, dependent: :restrict_with_error
  # У Курса есть несколько записей UserLesson, отслеживаемые через Lesson
  has_many :user_lessons, through: :lessons

  # Подключаем гем для отвлеживания событий в модели Курсы
  include PublicActivity::Model
  # Отслеживаем только активность текущего пользователя
  tracked owner: Proc.new { |controller, model| controller.current_user }

  # Перенесли логику из Home_Controller
  scope :latest, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }

  # выбираем все опубликованные/ проверенные курсы
  scope :published, -> { where(published: true)}
  scope :unpublished, -> { where(published: false)}
  scope :approved, -> { where(approved: true)}
  scope :unapproved, -> { where(approved: false)}


  # Метод для конвертации в строку полейБ возвращенных из БД (массивом)
  def to_s
    title
  end

  # Расширяем наш класс дополнением для отображения дружественных ссылок
  extend FriendlyId
  friendly_id :title, use: :slugged


  LANGUAGES = ["English", "Russian", "France", "Spanish"]

  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  LEVELS = ["Beginner", "Intermediate", "Advance"]

  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  # проверяем наличие записи, где user = ID , а курс текущему курсу
  def bought(user)
    self.enrollments.where(user_id: user.id, course_id: self.id).empty?
  end

  # Прогресс текущего Usera по прохождению курса( ан базе кол-ва просмотренных уроков)
  def progress(user)
    unless self.lessons_count == 0
      # Кол-во записей у этого курса в таблице UserLesson, где указан текущий пользователь
      # Деленное на количество уроков в данном курсе
      user_lessons.where(user: user).count / self.lessons_count.to_f * 100
    end
  end


  # Обновляем рейтинг Курса
  def update_rating
    # Если у Курса есть хоть какие подписки и нет Пустых рейтингов (n/)
    #
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      # Обновляем колонку, в нее записываем Среднее ( рейтинг). округленное до 2го знака, в тип float
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
    else
      # Если нет полписок, то выставляем рейтинг 0
      update_column :average_rating, (0)
    end
  end

end
