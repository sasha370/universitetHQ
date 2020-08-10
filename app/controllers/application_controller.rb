class ApplicationController < ActionController::Base
  # Перед посещением любой страницы мы должны аутентифицировать ползователя
  before_action :authenticate_user!

end
