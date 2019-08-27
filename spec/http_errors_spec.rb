RSpec.describe Pwinty::HttpErrors do
	it "will report authentication failure" do
		VCR.use_cassette('http_errors/auth') do
			old_merchant_id = Pwinty::MERCHANT_ID
			old_api_key = Pwinty::API_KEY

			Pwinty::MERCHANT_ID = nil
			Pwinty::API_KEY = nil

			expect { Pwinty::Order.list }.to raise_error(Pwinty::AuthenticationError)

			Pwinty::MERCHANT_ID = old_merchant_id
			Pwinty::API_KEY = old_api_key
		end
	end
end
