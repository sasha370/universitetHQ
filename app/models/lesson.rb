class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  validates :title, :content, :course, presence: true
  has_many :user_lessons, dependent: :destroy

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

  # Показывает, что данный урок был просмотрен учеником ( т.е. имеется запись в UserLessons)
  def viewed(user)
    self.user_lessons.where(user: user).present?
    # self.user_lessons.where(user_id: [user.id], lesson_id: [self.id]).empty?
  end


end
