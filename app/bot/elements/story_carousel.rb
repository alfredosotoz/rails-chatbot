module Elements
	class StoryCarousel
		attr_reader :source

		def initialize(source_id)
			@source = Source.find(source_id).api_id
		end

		def elements
				stories.map{ |story| element(story)}
		end

		private

		def element(story)
			{
				title: story["title"],
				image_url: story["urlToImage"],
				subtitle: story["description"],
				buttons:[
					{
						type: "web_url",
						url: story["url"],
						title: "Read Article",
						webview_height_ratio: "full"
					},
					{
						type: "element_share"
					}
				]
			}
		end

		def stories
			NewsApi::Client.new(source).top_headlines
		end
	end 
end