class Comment < ApplicationRecord

  # Counter_cache Обновляет счетчик Комментрий в соответвующих колонках в таблицах Lesson и User
  # когда создается или удаляется подведомственный комент
  belongs_to :lesson, counter_cache: true
  belongs_to :user, counter_cache: true

  validates :content, presence: true

  # Подключаем гем для отвлеживания событий в модели Курсы
  include PublicActivity::Model
  # Отслеживаем только активность текущего пользователя
  tracked owner: Proc.new { |controller, model| controller.current_user }


  def to_s
    content
  end

end
