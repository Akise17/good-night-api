# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_name  (name)
#
class User < ApplicationRecord
  has_many :trackings, dependent: :destroy

  has_many :outgoing_follows, class_name: 'Follow', foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :outgoing_follows, source: :followed

  has_many :incoming_follows, class_name: 'Follow', foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :incoming_follows, source: :follower

  validates :name, presence: true

  def follow(user_to_follow)
    followings << user_to_follow
  end

  def unfollow(user_to_unfollow)
    raise ActiveRecord::RecordNotFound unless followings.exists?(user_to_unfollow.id)

    followings.destroy(user_to_unfollow)
  end
end
