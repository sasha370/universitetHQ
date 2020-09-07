class UserMailer < ApplicationMailer

  def new_user(user)
    @user = user
    # Отправляем письмо всем Админам, distinct - удаляет дубли
    mail(to: User.with_role(:admin).distinct.pluck(:email), subject: "New registration")

  end

end
