class SourceSubscription < ActiveRecord::Base
	validates 	:user_id,
				:source_id,
				presence: true

	belongs_to :user
	belongs_to :source
end