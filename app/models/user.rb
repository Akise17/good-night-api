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

  validates :name, presence: true
end
