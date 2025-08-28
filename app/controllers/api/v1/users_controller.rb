# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_user!
  def create
    @resource = User.new(user_params)
    render_response if @resource.save!
  end

  def update
    render_response if @resource.update!(user_params)
  end

  private

  def user_params
    params.require(:user)
          .permit(:name)
  end
end
