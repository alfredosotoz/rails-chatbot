require "facebook/messenger"

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe

Bot.on :message do |message|
	brain = Brain.new
	brain.set_message(message)
	brain.start_typing
	brain.create_log
	brain.process_message
	brain.stop_typing
end

Bot.on :postback do |postback|
	brain = Brain.new
	brain.set_postback(postback)
	brain.start_typing
	brain.create_log
	brain.process_postback
	brain.stop_typing
end

Facebook::Messenger::Thread.set(
	setting_type: "call_to_actions",
	thread_state: "new_thread",
	call_to_actions: [
		{
			payload: "new_thread"
		}
	]
)