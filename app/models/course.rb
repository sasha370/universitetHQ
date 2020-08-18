class Course < ApplicationRecord
  # Валидация для новых курсов, обязательно присутствие названия и описания не менее 5 символов
  validates :title, :short_description, :language, :level, :price, presence: true
  validates :description, presence: true, length: { minimum: 5 }

  # Подключаем встроенный редактор текста для поля вуыскшзешщт
  has_rich_text :description


  # Курс принадлежит только одному пользователю
  belongs_to :user
  # Курс имеет множество уроков, которые удаляются вместе с курсом
  has_many :lessons, dependent: :destroy
  has_many :enrollments

  # Подключаем гем для отвлеживания событий в модели Курсы
  include PublicActivity::Model
  # Отслеживаем только активность текущего пользователя
  tracked owner: Proc.new { |controller, model| controller.current_user }

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
