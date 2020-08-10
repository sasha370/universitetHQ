class Course < ApplicationRecord
  # Валидация для новых курсов, обязательно присутствие названия и описания не менее 5 символов
  validates :title, presence: true
  validates :description, presence: true, length: {minimum: 5}

  # Подключаем встроенный редактор текста для поля вуыскшзешщт
  has_rich_text :description

  # Курс принадлежит только одному пользователю
  belongs_to :user


  # Метод для конвертации в строку полейБ возвращенных из БД (массивом)
  def to_s
    title
  end

end
