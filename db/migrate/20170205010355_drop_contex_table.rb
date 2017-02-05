class DropContexTable < ActiveRecord::Migration
  def change
  	drop_table :contexts
  end
end
