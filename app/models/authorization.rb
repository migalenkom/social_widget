class Authorization < ActiveRecord::Base
	belongs_to :user
	has_one :widget

	after_create :fetch_details

	def refresh_auth_token
		data = {
				:client_id => ENV['GOOGLE_KEY'],
				:client_secret => ENV['GOOGLE_SECRET'],
				:refresh_token => refresh_token,
				:grant_type => "refresh_token"
		}
		response = ActiveSupport::JSON.decode(RestClient.post "https://accounts.google.com/o/oauth2/token", data)

		if response["access_token"].present?
			update_attributes(
					token: response["access_token"],
					expires_at: Time.now + (response["expires_in"].to_i).seconds).to_i
		end
	rescue RestClient::BadRequest => e
		# Bad request
	rescue
		# else bad happened
	end

	def expired?
		Time.at(expires_at) < Time.now
	end

	def fresh_token
		refresh_auth_token if expired?
		token
	end

	def fetch_details
		self.send("fetch_details_from_#{self.provider.downcase}")
	end


	def fetch_details_from_facebook
		graph = Koala::Facebook::API.new(self.token)
		facebook_data = graph.get_object("me")
		self.username = facebook_data['username']
		self.save
	end

	def fetch_details_from_twitter
	end

	def fetch_details_from_github
	end

	def fetch_details_from_linkedin
	end

	def fetch_details_from_google_oauth2
	end
end
