class Course < ApplicationRecord
  # Валидация для новых курсов, обязательно присутствие названия и описания не менее 5 символов
  validates :title, :short_description, :language, :level, :price,  presence: true
  validates :description, presence: true, length: {minimum: 5}

  # Подключаем встроенный редактор текста для поля вуыскшзешщт
  has_rich_text :description


  # Курс принадлежит только одному пользователю
  belongs_to :user
  # Курс имеет множество уроков, которые удаляются вместе с курсом
  has_many :lessons, dependent:  :destroy

  # Подключаем гем для отвлеживания событий в модели Курсы
  include PublicActivity::Model
  # Отслеживаем только активность текущего пользователя
  tracked owner: Proc.new{|controller, model| controller.current_user}

  # Метод для конвертации в строку полейБ возвращенных из БД (массивом)
  def to_s
    title
  end

  # Расширяем наш класс дополнением для отображения дружественных ссылок
  extend FriendlyId
  friendly_id :title, use: :slugged


  LANGUAGES = ["English", "Russian", "France", "Spanish"]
  def self.languages
    LANGUAGES.map { |language| [language,language]}
  end

  LEVELS = ["Beginner", "Intermediate", "Advance"]
  def self.levels
    LEVELS.map { |level| [level,level]}
  end
end
