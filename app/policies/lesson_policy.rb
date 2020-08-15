class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end


  #Только админ и владелец могут видеть описание лекции
  # Проверка покупки - выдает true? если записи нет? т.е. нам надо false
  def show?
    @user.has_role?(:admin) || @record.course.user_id == @user.id || @record.course.bought(@user) == false
  end

  def edit?
    # Только владелец курса может редактировать Лекцию
    # @record берется из application_policy и равна @lesson
    @record.course.user == @user
  end

  def update?
    @record.course.user == @user
  end

  def new?
    #@user.has_role?(:teacher)
  end

  def create?
    #@user.has_role?(:teacher)
    @record.course.user == @user
  end

  def destroy?
    @record.course.user == @user
  end
end
