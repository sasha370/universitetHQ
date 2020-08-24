class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  validates :title, :content, :course, presence: true
  validates :title, length: {maximum: 70}
  validates_uniqueness_of :title, scope: :course # у одного курса не может быть два урока с одним названием
  has_many :user_lessons, dependent: :destroy

  # Подключаем встроенный редактор текста для поля вуыскшзешщт
  has_rich_text :content

  # У каждого урока  есть прикрепленный файл ( видео и превьюха к нему), который будет хранится на S3
  has_one_attached :video
  has_one_attached :video_thumbnail
  validates :video, content_type: ['video/mp4'],
            size: { less_than: 50.megabytes, message: "image must be less that 50 MB" }
  validates :video_thumbnail,content_type: [:png, :jpg, :jpeg],
            size: { less_than: 500.kilobytes, message: "image must be less that 500 Kb" }


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
