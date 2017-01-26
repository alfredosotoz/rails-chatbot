class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
    	t.string :name
    	t.string :api_id
    	t.string :image_url
    	t.timestamps
    end
  end
end
