class User < ActiveRecord::Base
	def first_name
		full_name.split(" ").first
	end
end