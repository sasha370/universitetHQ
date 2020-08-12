class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

# Юзер может иметь несколько Курсов
  has_many :courses

  # Метод для конвертации в строку полейБ возвращенных из БД (массивом)
  def to_s
    email
  end

end
