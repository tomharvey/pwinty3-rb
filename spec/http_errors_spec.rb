RSpec.describe Pwinty3::HttpErrors do
	it "will report authentication failure" do
		VCR.use_cassette('http_errors/auth') do
			Pwinty3::MERCHANT_ID = nil
			Pwinty3::API_KEY = nil

			expect { Pwinty3::Order.list }.to raise_error(Pwinty3::AuthenticationError)
		end
	end
end
