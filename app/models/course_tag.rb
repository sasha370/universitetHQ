class CourseTag < ApplicationRecord
  # Заисимость между Тегами и Курсами

  belongs_to :course  # привязана множеством к Курсам
  belongs_to :tag, counter_cache: true # привязано множеством к Тегам, и имеет счетчик тегов для каждого курса

end
