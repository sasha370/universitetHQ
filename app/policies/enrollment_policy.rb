
class EnrollmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end


  #Только админ могут видеть описание лекции
  def index?
    @user.has_role?(:admin)
  end

  def edit?
    # Только владелец курса может редактировать запись
    # @record берется из application_policy и равна @enrollment
    @record.user == @user
  end

  def update?
    @record.user == @user
  end


  def destroy?
    @user.has_role?(:admin)
  end

  def certificate?
    # количество лекций в Курсе данной полписки  ====  кол-ву записей просмотренных пользователем
    @record.course.lessons_count == @record.course.user_lessons.where(user: @record.user).count
  end
end
