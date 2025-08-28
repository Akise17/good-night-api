class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  include ApiExceptionHandler

  before_action :authenticate_user!

  def authenticate_user!
    # TODO: implement authentication logic here

    user_id = request.headers['X-User-Id'] || params[:user_id]

    if user_id.present? && (@current_user = User.find_by(id: user_id))
      true
    else
      raise Unauthorized
    end
  end

  def current_user
    @current_user
  end
end
