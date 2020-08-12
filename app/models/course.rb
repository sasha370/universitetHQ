class Course < ApplicationRecord
  # Валидация для новых курсов, обязательно присутствие названия и описания не менее 5 символов
  validates :title, :short_description, :language, :level, :price,  presence: true
  validates :description, presence: true, length: {minimum: 5}

  # Подключаем встроенный редактор текста для поля вуыскшзешщт
  has_rich_text :description


  # Курс принадлежит только одному пользователю
  belongs_to :user


  # Метод для конвертации в строку полейБ возвращенных из БД (массивом)
  def to_s
    title
  end

  # Расширяем наш класс дополнением для отображения дружественных ссылок
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Если использовать данную запись то будут генерироваться рандомные названия для статей в URL
  # friendly_id :generated_slug, use: :slugged
  # def generated_slag
  #   require 'securerandom'
  #   @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  # end
end
