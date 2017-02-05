class User < ActiveRecord::Base
	
	validates :fb_id, :full_name, presence: true 

	has_many :source_subscriptions
	has_many :contexts

	def first_name
		full_name.split(" ").first
	end

	def subscribed_to?(source_id)
		source_subscriptions.where(source_id: source_id).any?
	end
end