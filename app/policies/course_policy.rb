class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    @record.user == @user
  end

  def show?
    @record.published && @record.approved ||
      @user.present? && @user.has_role?(:admin) ||
      @user.present? && @record.user_id == @user.id ||
      @user.present? && @record.bought(@user)

  end

  def new?
    @user.has_role?(:teacher)
  end

  def create?
    @user.has_role?(:teacher)
  end

  def destroy?
    @record.user == @user && @record.enrollments.none?
  end

  def owner?
    @record.user == @user
  end

  def admin_or_owner?
    @record.user == @user || @user.has_role?(:admin)
  end

  def approve?
    @user.has_role?(:admin)
  end
end
