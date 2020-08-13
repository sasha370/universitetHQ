class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         # добавили tracable и confirmable, первый отслеживает даты и кол-во визитов, второй требует подтверждение
         # при регитсрации черз почту.
         # инструкция в WIKI для devise
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

# Юзер может иметь несколько Курсов
  has_many :courses

# Метод для конвертации в строку полейБ возвращенных из БД (массивом)
  def to_s
    email
  end

  # Метод обрезает email до собакиБ чтобы сделать из него логин для отображения в карточке
  def username
      self.email.split(/@/).first
  end

end
