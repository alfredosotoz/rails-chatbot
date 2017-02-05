class AddScheduleToSourceSubscriptions < ActiveRecord::Migration
  def change
  	add_column :source_subscriptions, :schedule, :string
  end
end
