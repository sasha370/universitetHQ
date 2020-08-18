class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  validates :title, :content, :course, presence: true

  # Подключаем встроенный редактор текста для поля вуыскшзешщт
  has_rich_text :content

  # Расширяем наш класс дополнением для отображения дружественных ссылок
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Подключаем гем для отвлеживания событий в модели Lessons
  include PublicActivity::Model
  # Отслеживаем только активность текущего пользователя
  tracked owner: Proc.new{|controller, model| controller.current_user}
  def to_s # преобразует массив выдачи в строчку
    title
  end


end
