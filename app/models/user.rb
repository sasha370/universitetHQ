class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable,  and :omniauthable
  devise :database_authenticatable, :registerable,
         # добавили tracable и confirmable, первый отслеживает даты и кол-во визитов, второй требует подтверждение
         # при регитсрации черз почту.
         # инструкция в WIKI для devise
         :recoverable, :rememberable, :validatable, :trackable, :confirmable

  rolify # Модель попадает в распределение ролей. Gem Rolify(прописывается само)

  has_many :courses # Юзер может иметь несколько Курсов


  def to_s # Метод для конвертации в строку полейБ возвращенных из БД (массивом)
    email
  end


  def username # Метод обрезает email до собакиБ чтобы сделать из него логин для отображения в карточке
    self.email.split(/@/).first
  end


  # После создания пользователя, назначаем ему роль поумолчанию
  after_create :assign_default_role

  def assign_default_role
    # Если пользователь создал приложение = первым зарегестрировался, то он становится 777
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:student)
      self.add_role(:teacher)
    else
      self.add_role(:student) if self.roles.blank?
      self.add_role(:teacher)
    end
  end

end
