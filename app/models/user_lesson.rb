class UserLesson < ApplicationRecord
  # Принадлежит к User и Lesson
  # Содержит записи о том какой пользователь какой урок открывал
  belongs_to :user, counter_cache: true
  belongs_to :lesson, counter_cache: true

  # И Юзер и Урок должны присутсвовать в записи
  validates :user, :lesson, presence: true

  # Один пользователь может только один раз открыть урок, один урок может только один раз записаться на юзера
  validates_uniqueness_of :user_id, scope: :lesson_id
  validates_uniqueness_of :lesson_id, scope: :user_id


end
