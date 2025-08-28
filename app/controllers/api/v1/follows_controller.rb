# frozen_string_literal: true

class Api::V1::FollowsController < Api::V1::BaseController
  before_action :set_resource, only: %i[follow unfollow]

  def follow
    @resource.follow(@user_to_follow)
    # 204 No Content when success follow
  end

  def unfollow
    @resource.unfollow(@user_to_follow)
    # 204 No Content when success unfollow
  end

  private

  def set_resource
    @resource = current_user
    @user_to_follow = User.find(params[:id])
  end
end
