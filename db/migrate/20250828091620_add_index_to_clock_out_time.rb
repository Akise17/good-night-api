# frozen_string_literal: true

class AddIndexToClockOutTime < ActiveRecord::Migration[7.2]
  def change
    add_index :trackings, :clock_out_time
  end
end
