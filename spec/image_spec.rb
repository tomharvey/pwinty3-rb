RSpec.describe Pwinty::Image do

    it "can handle an image with partial attributes" do
        image = Pwinty::Image.new({
            "attributes": {
                "paperType": "hge",
                "substrateWeight": "310gsm"
            },
            "copies": 1,
            "errorMessage": nil,
            "id": 1,
            "md5Hash": nil,
            "previewUrl": nil,
            "price": 0,
            "priceToUser": nil,
            "sizing": "Crop",
            "sku": "GLOBAL-PHO-4X6-PRO",
            "status": "NotYetDownloaded",
            "thumbnailUrl": nil,
            "url": "http://example.com/mytestphoto.jpg"
        })
        expect(image.id).to be 1
    end

    it "can handle an image with empty attributes hash" do
        image = Pwinty::Image.new({
            "attributes": {},
            "copies": 1,
            "errorMessage": nil,
            "id": 1,
            "md5Hash": nil,
            "previewUrl": nil,
            "price": 0,
            "priceToUser": nil,
            "sizing": "Crop",
            "sku": "GLOBAL-PHO-4X6-PRO",
            "status": "NotYetDownloaded",
            "thumbnailUrl": nil,
            "url": "http://example.com/mytestphoto.jpg"
        })
        expect(image.id).to be 1
    end
end