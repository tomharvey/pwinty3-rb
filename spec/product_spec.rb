RSpec.describe Pwinty::Product do

  it "can get a product's details" do
    VCR.use_cassette('product/finding_an_product_detail') do
      product = Pwinty::Product.find('GLOBAL-CAN-4X6')
      expect(product).to be_kind_of(Pwinty::Product)
      expect(product.sku).to eq('GLOBAL-CAN-4X6')
      expect(product.description).to eq('Stretched Canvas on a 38mm Standard Stretcher Bar, 4x6 inches / 10x15 cm')
      expect(product.productDimensions.width).to eq(4.0)
      expect(product.productDimensions.height).to eq(6.0)
      expect(product.productDimensions.units).to eq("in")
    end
  end

end