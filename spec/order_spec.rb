RSpec.describe Pwinty::Order do
  it "has an Order class" do
    expect(Pwinty::Order).to be_truthy
  end

  it "can stub an order" do
    order = stub_order
    expect(order.recipient.name).to eq('Testy McTestface')
    expect(order.recipient.address.line1).to eq('1 Main Street')
    expect(order.recipient.address.countryCode).to eq('US')
    expect(order.shippingMethod).to eq('Budget')
    expect(order.items[0].sku).to eq('GLOBAL-PHO-4X6-PRO')
    expect(order.items[0].sizing).to eq('fillPrintArea')
    expect(order.items[0].assets[0].url).to eq('https://example.com/image.jpg')
    expect(order.items[0].assets[0].printArea).to eq('default')
  end

  it "can get an order" do
    VCR.use_cassette('order/finding_an_order') do
      order = Pwinty::Order.find('ord_980865')
      expect(order).to be_kind_of(Pwinty::Order)
      expect(order.id).to eq('ord_980865')
    end
  end

  it "can list orders" do
    VCR.use_cassette('order/list') do
      orders = Pwinty::Order.list(limit: 50)

      expect(orders[0]).to be_kind_of(Pwinty::Order)
      expect(orders[0].id).to eq('ord_980865')
      expect(orders[0].merchantReference).to eq('0448e0a12454461abce0be77613199d0-1621003640')
      expect(orders[0].shippingMethod).to eq('Budget')
      expect(orders.count).to eq(50)

      all_orders = Pwinty::Order.list()
      expect(all_orders.count).to eq(70)

    end
  end

  it "can add an image to an order" do
    order = stub_order
    order.add_image(
      sku: "GLOBAL-PHO-4X6-PRO",
      url: "http://example.com/mytestphoto.jpg",
      copies: 2,
    )

    expect(order.items.count).to eq 2
    expect(order.items[1].sku).to eq('GLOBAL-PHO-4X6-PRO')
    expect(order.items[1].copies).to eq(2)
    expect(order.items[1].assets[0].url).to eq('http://example.com/mytestphoto.jpg')
  end

  it "can serialize" do
    order = stub_order
    hashed_order = order.serializable
    expect(hashed_order).to eq({
      :items => [{:assets=>[{:printArea=>"default", :url=>"https://example.com/image.jpg"}], :attributes=>{:finish=>"lustre"}, :copies=>1, :sizing=>"fillPrintArea", :sku=>"GLOBAL-PHO-4X6-PRO"}],
      :recipient => {:address=>{:countryCode=>"US", :line1=>"1 Main Street", :postalOrZipCode=>"90210", :townOrCity=>"Holywood"}, :name=>"Testy McTestface"},
      :shippingMethod => "Budget",
    })
  end

  it "can build and submit an order" do
    VCR.use_cassette('order/submit') do
      order = stub_order
      submitted = order.submit
      expect(submitted.id).to eq('ord_1059863')
    end
  end

  it "can cancel an order" do
    VCR.use_cassette('order/cancel') do
      order = Pwinty::Order.new(order_stub_attrs.update(id: 'ord_1059863'))
      cancelled_order = order.cancel
      expect(cancelled_order.status.stage).to eq('Cancelled')
    end
  end

end
