RSpec.describe Pwinty::OrderItem do
  it "has an OrderItem class" do
    expect(Pwinty::OrderItem).to be_truthy
  end

  it "can stub an order_item" do
    order_item = stub_order_item
    expect(order_item.sku).to eq('GLOBAL-PHO-4X6-PRO')
  end

  it "can serialize" do
    order_item = stub_order_item
    hashed_item = order_item.serializable
    expect(hashed_item).to eq({
      :assets=>[
        {
          :printArea=>"default",
          :url=>"https://example.com/image.jpg"
        }
      ],
      :attributes=>{
        :finish=>"lustre"
      },
      :copies=>1,
      :sizing=>"fillPrintArea",
      :sku=>"GLOBAL-PHO-4X6-PRO",
    })
  end

end