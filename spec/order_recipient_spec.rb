RSpec.describe Pwinty::OrderRecipient do
  it "has an OrderRecipient class" do
    expect(Pwinty::OrderRecipient).to be_truthy
  end

  it "can stub an order_recipient" do
    order_recipient = stub_order_recipient
    expect(order_recipient.name).to eq('Testy McTestface')
  end

  it "can serialize" do
    order_recipient = stub_order_recipient
    hashed_recipient = order_recipient.serializable
    expect(hashed_recipient).to eq({
      :name=>'Testy McTestface',
      :address=>{
        :countryCode=>"US",
        :line1=>"1 Main Street",
        :postalOrZipCode=>"90210",
        :townOrCity=>"Holywood",
      }
    })
  end
end
