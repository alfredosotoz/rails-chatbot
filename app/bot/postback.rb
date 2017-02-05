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
		when /start_subscribe&source_id=(\d+)/
			ask_for_schedule($1.to_i)
		when /subscribe&schedule=(\w+)/
			subscribe($1)
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

	def ask_for_schedule(source_id)
		user.contexts.create(state: "subscribing", param: source_id)

		[
			{
				type: "quick_replies",
				text: "When would you like to receive updates for #{Source.find(source_id).name}?",
				replies:[
					{
						content_type: "text",
						title: "Morning",
						payload: "subscribe&schedule=morning"
					},
					{
						content_type: "text",
						title: "Noon",
						payload: "subscribe&schedule=noon"
					},
					{
						content_type: "text",
						title: "Evening",
						payload: "subscribe&schedule=evening"
					}
				]
			}
		]
	end

	def subscribe(schedule)
		source_id = user.contexts.state("subscribing").last.param
		user.source_subscriptions.create(source_id: source_id, schedule: schedule)
		send_subscription_confirmation(source_id, schedule)
	end 

	def send_subscription_confirmation(source_id, schedule)
		user.contexts.create(state: "just_subscribed", param: source_id)

		[
			{
				type: "text",
				text: "Great. You'll receive top stories from #{Source.find(source_id).name} daily at #{schedule}."
			}
		]
	end
end