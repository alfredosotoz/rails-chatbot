module Elements
	class SourceCarousel
		attr_reader :user

		def initialize(user_id)
			@user = User.find(user_id)
		end

		def elements
			source = Source.all 
			elements = source.map{ |s| element(s) }
		end

		private 

		def element(source)
			skel = skeleton(source)
			skel[:buttons] << tail(source.id)
			skel
		end

		def skeleton(source)
			{
				title: source.name,
				image_url: source.image_url,
				subtitle: "",
				buttons: [
					{
						type: "postback",
						title: "Top Stories",
						payload: "top_stories&source_id=#{source.id}"
					}
				]
			}
		end

		def tail(source_id)
			if user.subscribed_to?(source_id)
				{
					type: "postback",
					title: "Unsubscribe",
					payload: "unsubscribe&source_id=#{source_id}"
				}
				else
					{
						type: "postback",
						title: "Subscribe",
						payload: "subcribed&source_id=#{source_id}"
					}
				end
			end
	end
end