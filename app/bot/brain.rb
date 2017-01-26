require "facebook/messenger"

class Brain
	include Facebook::Messenger

	attr_reader :message, :postback
	attr_reader :sender, :text, :attachments

	def set_message(message)
    @message     = message
    @sender      = message.sender
    @text        = message.text
    @attachments = message.attachments
  end

	def set_postback(postback)
		@postback = postback
		@sender = postback.sender
	end

	def start_typing
		Facebook::Client.new.set_typing_on(sender["id"])
	end

	def stop_typing
		Facebook::Client.new.set_typing_off(sender["id"])
	end

	def process_message
		if text.present?
			send_text("Hi #{user.first_name}")
		else
			send_text("Sorry, I don't handle attachments")
		end
	end

	def process_postback
		resp = Postback.new(postback.payload, user.id).process

		resp.each do |r|
			case r[:type]
			when "text"
				send_text(r[:text])
			when "generic"
				send_generic_template(r[:elements])
			else
				fail "invalid type"
			end
		end
	end

	def create_log
		if message.present?
			Log.create(
				user_id: user.id,
				fb_message_id: message.id,
				message_type: message_type,
				sent_at: message.sent_at
			)
		else
			Log.create(
				user_id: user.id,
				message_type: "postback",
				sent_at: postback.sent_at
			)
		end
	end

	private 

	def send_text(text)
		Bot.deliver(
			recipient: sender,
			message: {
				text: text
			}
		)
	end

	def send_generic_template(elements)
		Bot.deliver(
			recipient: sender,
			message: {
				attachment: {
					type: "template",
					payload: {
						template_type: "generic", 
						elements: elements
					}
				}
			}
		)
	end

	def message_type
		text.present? ? "text" : attachments.first["type"]
	end

	def user
		@user ||= set_user
	end

	def set_user
		@user = User.find_by(fb_id: sender["id"])

		if @user.nil?
			fb_user = Facebook::Client.new.get_user(sender["id"])
			@user = User.create(
					fb_id: sender["id"],
					full_name: fb_user["first_name"] + " " + fb_user["last_name"],
					gender: fb_user["gender"],
					locale: fb_user["locale"],
					timezone: fb_user["timezone"]
				)
		end
		@user
	end
end