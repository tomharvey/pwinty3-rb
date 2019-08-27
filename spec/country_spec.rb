RSpec.describe Pwinty::Country do
	it "can list countries" do
		VCR.use_cassette('country/list') do
			countries = Pwinty::Country.list

			expect(countries[0]).to be_kind_of(Pwinty::Country)
			expect(countries[0].name).to eq('AFGHANISTAN')
			expect(countries[0].isoCode).to eq('AF')
			expect(countries.count).to eq(250)
		end
	end
end
