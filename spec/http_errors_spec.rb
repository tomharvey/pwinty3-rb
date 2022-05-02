RSpec.describe Pwinty::HttpErrors do
  it "will report authentication failure" do
    VCR.use_cassette('http_errors/auth') do
      old_merchant_id = Pwinty::MERCHANT_ID
      old_api_key = Pwinty::API_KEY

      Pwinty::MERCHANT_ID = nil
      Pwinty::API_KEY = nil

      expect { Pwinty::Order.list }.to raise_error(
        Pwinty::AuthenticationError,
        '{"outcome":"NotAuthenticated","traceParent":"00-eeaf24c8cbd9613209a7ae04dcd225ff-4a3aa3c5cf436f4b-00"}'
      )

      Pwinty::MERCHANT_ID = old_merchant_id
      Pwinty::API_KEY = old_api_key
    end
  end

  it "will report validation errors" do
    VCR.use_cassette('http_errors/validation') do
      order = Pwinty::Order.new({shippingMethod: 'Budget'})
      expect { order.submit }.to raise_error(
        Pwinty::ValidationError,
        '{"outcome":"ValidationFailed","failures":{"recipient.name":[{"code":"Required","providedValue":null}],"recipient.address.line1":[{"code":"Required","providedValue":null}],"recipient.address.townOrCity":[{"code":"Required","providedValue":null}],"recipient.address.countryCode":[{"code":"Required","providedValue":null}],"recipient.address.postalOrZipCode":[{"code":"Required","providedValue":null}],"items":[{"code":"MustNotBeEmptyArray","providedValue":[]}]},"traceParent":"00-3c88eb3f8a719e0cf398ee2f7ad55d33-895b00afcd143641-00"}'
      )
    end
  end

  it "will report NotFound errors" do
    VCR.use_cassette('http_errors/not_found') do
      expect { order = Pwinty::Order.find('ord_9') }.to raise_error(Pwinty::NotFound)
    end
  end

end
