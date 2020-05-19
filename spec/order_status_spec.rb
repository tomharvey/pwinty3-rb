RSpec.describe Pwinty::OrderStatus do
  it "has an OrderStatus class" do
    expect(Pwinty::OrderStatus).to be_truthy
  end

    it "can check an order's status" do
      VCR.use_cassette('order_status/check') do
        status = Pwinty::OrderStatus.check(794822)

        expect(status).to be_kind_of(Pwinty::OrderStatus)
        expect(status.id).to eq(794822)
        expect(status.isValid).to be(false)
        expect(status.generalErrors).to contain_exactly('NoItemsInOrder', 'PostalAddressNotSet', 'PostalAddressNotSet')
      end
    end

end
