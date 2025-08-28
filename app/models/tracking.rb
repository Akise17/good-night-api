# frozen_string_literal: true

# == Schema Information
#
# Table name: trackings
#
#  id             :bigint           not null, primary key
#  clock_in_time  :datetime
#  clock_out_time :datetime
#  sleep_duration :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_trackings_on_clock_out_time  (clock_out_time)
#  index_trackings_on_created_at      (created_at)
#  index_trackings_on_sleep_duration  (sleep_duration)
#  index_trackings_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Tracking < ApplicationRecord
  belongs_to :user

  before_validation :set_clock_in_time, on: :create

  before_update :calculate_sleep_duration, if: :clock_out_time_changed?

  validates :clock_in_time, presence: true
  validate :tracking_status_must_be_valid, on: :update

  default_scope { order(created_at: :desc) }

  scope :by_date, lambda { |range|
    return self if range.blank?

    start_date = range.split(',').first.to_date.beginning_of_day
    end_date = range.split(',').last.to_date.end_of_day
    where(created_at: start_date..end_date)
  }

  scope :followings_of, lambda { |user|
    where(user: user.followings)
  }

  scope :completed, -> { where.not(clock_out_time: nil) }


  scope :by_duration, -> { reorder(sleep_duration: :desc) }

  def set_clock_in_time
    self.clock_in_time ||= DateTime.current
  end

  def calculate_sleep_duration
    return unless clock_in_time.present? && clock_out_time.present?

    self.sleep_duration = (clock_out_time - clock_in_time).to_i
  end

  def completed?
    clock_out_time_was.present?
  end

  private

  def tracking_status_must_be_valid
    errors.add(:base, :completed) if completed?
  end
end
