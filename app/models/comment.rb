class Comment < ApplicationRecord

  # Counter_cache Обновляет счетчик Комментрий в соответвующих колонках в таблицах Lesson и User
  # когда создается или удаляется подведомственный комент
  belongs_to :lesson, counter_cache: true
  belongs_to :user, counter_cache: true

  validates :content, presence: true

  def to_s
    comment
  end
end
