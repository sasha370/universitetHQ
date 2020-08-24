class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  validates :title, :content, :course, presence: true
  validates :title, uniqueness: true, length: {maximum: 70}
  has_many :user_lessons, dependent: :destroy

  # Подключаем встроенный редактор текста для поля вуыскшзешщт
  has_rich_text :content

  # Расширяем наш класс дополнением для отображения дружественных ссылок
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Подключаем гем для отвлеживания событий в модели Lessons
  include PublicActivity::Model
  # Отслеживаем только активность текущего пользователя
  tracked owner: Proc.new { |controller, model| controller.current_user }

  # Для ранжирования уроков (перестановки)
  include RankedModel
  ranks :row_order,
        :with_same => :course_id # уроки принадлежат Курсу,т.е сортировка внутри курса


  def to_s # преобразует массив выдачи в строчку
    title
  end

  # Методы для престановки уроков
  def prev
    # Предыдущий. Тот у которого порядковый номер меньше текущего (их много). Выбираем последний, т.е. предыдущий
    course.lessons.where("row_order < ?", row_order).order(:row_order).last
  end

  def next
    # Следующий. Все уроки у которых порядковй номер больше текущего. Выбираем первый из них
    course.lessons.where("row_order > ?", row_order).order(:row_order).first
  end

  # Показывает, что данный урок был просмотрен учеником ( т.е. имеется запись в UserLessons)
  def viewed(user)
    self.user_lessons.where(user: user).present?
    # self.user_lessons.where(user_id: [user.id], lesson_id: [self.id]).empty?
  end


end
