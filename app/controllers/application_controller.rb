class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pagy::Backend

  after_action :user_activity

  include Pundit
  protect_from_forgery
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  include PublicActivity::StoreController

  before_action :set_global_variables
  def set_global_variables
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search)
  end

  private

  def user_not_authorized
    flash[:alert] =  " You are not authorized to perfome this action"
    redirect_to(request.referrer || root_path)
  end

  def user_activity
    current_user.try :touch
  end
end
