class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end


  def destroy?
   # только владелец может удалить и только если нет подписок
    @user.has_role?(:admin) || @record.course.user_id == @user.id || @record.course.bought(@user) == false
  end


end