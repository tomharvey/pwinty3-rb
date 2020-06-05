RSpec.describe Pwinty::OrderStatus do
  it "has an OrderStatus class" do
    expect(Pwinty::OrderStatus).to be_truthy
  end

  it "can check an order's status" do
    VCR.use_cassette('order_status/check') do
      created_order = create_order
      status = Pwinty::OrderStatus.check(created_order.id)

      expect(status).to be_kind_of(Pwinty::OrderStatus)
      expect(status.id).to eq(created_order.id)
      expect(status.isValid).to be(false)
      expect(status.generalErrors).to contain_exactly('NoItemsInOrder', 'PostalAddressNotSet', 'PostalAddressNotSet')
    end
  end

end
