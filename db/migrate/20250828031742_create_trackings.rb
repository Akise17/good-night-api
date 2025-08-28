class CreateTrackings < ActiveRecord::Migration[7.2]
  def change
    create_table :trackings do |t|
      t.references :user, null: false, foreign_key: true, index: true

      t.datetime :clock_in_time
      t.datetime :clock_out_time
      t.integer  :sleep_duration, index: true, default: 0

      t.timestamps
    end

    add_index :trackings, :created_at
  end
end
