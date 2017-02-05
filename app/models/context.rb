class Context < ActiveRecord::Base
	belongs_to :user

	validates :user_id, presence: true

	scope :state, -> (state) { order(:created_at).where(state: state) }

	before_create do 
		delete_oldest
	end

	def delete_oldest
		if user.contexts.count > 5
			user.contexts.order(:created_at).first.delete
		end
	end
end