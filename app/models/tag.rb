class Tag < ApplicationRecord
  # У тегов есть много курсов, через промежуточную таблицу
  has_many :course_tags
  has_many :courses, through: :course_tags

  # Nti должен быть уникальным и иметь длинну от 1 до 25 символов
  validates :name, length: {minimum: 1, maximum: 25}, uniqueness: true

end
