class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.has_role?(:admin)
  end

  def edit?
    # Только админ и владелец могу редактировать
    # @record берется из application_policy и равна @course
    @user.has_role?(:admin)
  end

  def update?
    @user.has_role?(:admin)
  end



end
