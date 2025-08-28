class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :authenticate_user!

  def authenticate_user!
    # TODO: implement authentication logic here
    # For now, we'll just assume the user is authenticated

    true
  end
end
