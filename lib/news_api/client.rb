module NewsApi
	class Client
		attr_reader :source, :base_url
		
		def initialize
			@source = source
			@base_url = "https://newsapi.org/v1"

		end

		def top_headlines
			options = {
				source: source,
				sortBy: "top",
				apiKey: ENV["NEWS_API_KEY"]

			}

			data = JSON.load(get("articles", options))
			data = ['"articles']
		end

		private 

		def get(path, options = {} )
			conn = Faraday.new(base_url)
			resp = conn.get(path, options)
			resp.body
		end
	end
end