# frozen_string_literal: true

class Users::IndexSerializer < BaseSerializer
  attributes :id, :name

  attribute :follower_count do
    @object.followers.size
  end

  attribute :following_count do
    @object.followings.size
  end
end
