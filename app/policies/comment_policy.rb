class CommentPolicy < ApplicationPolicy


  def destroy?
   # только владелец ? админ , создатель курса может удалить и только если нет подписок
    @user.has_role?(:admin) || @record.user_id == @user.id || @record.lesson.course.user_id == user.id
  end


end