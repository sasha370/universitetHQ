class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    # Только владелец могу редактировать
    # @record берется из application_policy и равна @course
    # @user.has_role?(:admin)  ||    Админа убрали, чтобы он не редактировал курс
    @record.user == @user
  end

  def show?
    # Курс виден если:
    # - он опубликован и проверен
    # если это Админ
    # если это хозяин курса
    # если курс уже купил студент
    @record.published && @record.approved ||
        @user.present? && @user.has_role?(:admin) ||
        @user.present? && @record.user_id == @user.id ||
        @record.bought(@user)

  end

  def update?
    # @user.has_role?(:admin)  ||
    @record.user == @user
  end

  def new?
    @user.has_role?(:teacher)
  end

  def create?
    @user.has_role?(:teacher)
  end

  def destroy?
    @user.has_role?(:admin) || @record.user == @user
  end

  def owner?
    @record.user == @user
  end

  # Подтверждение курса
  def approve?
    @user.has_role?(:admin)
  end
end
