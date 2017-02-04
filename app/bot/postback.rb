class Postback
	attr_reader :payload, :user

	def initialize(payload, user_id)
		@payload = payload
		@user = User.find(user_id)
	end

	def process
		case payload
		when "new_thread"
			send_onboard
		when /top_stories&source_id=(\d+)/
			send_top_stories($1.to_i)
		end
	end

	private

	def send_onboard
		items =
		[
			{
				type: "text",
				text: "Hello #{user.first_name}. I'll send you top news daily"
			},
			{
				type: "text",
				text: "Here's a list of publications I have available"
			}
		]
		items + sources
	end

	def sources
		[
			{
				type: "generic",
				elements: Elements::SourceCarousel.new(user.id).elements
			}
		]
	end

	def send_top_stories(source_id)
		[
			{
				type: "text",
				text: "Here are the top stories for #{Source.find(source_id).name }"
			},
			{
				type: "generic",
				elements: Elements::StoryCarousel.new(source_id).elements
			}
		]
	end
end