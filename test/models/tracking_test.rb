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
require 'test_helper'

class TrackingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
