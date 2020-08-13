class Lesson < ApplicationRecord
  belongs_to :course
  validates :title, :content, :course, presence: true

  # Расширяем наш класс дополнением для отображения дружественных ссылок
  extend FriendlyId
  friendly_id :title, use: :slugged

end
