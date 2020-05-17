# Pwinty

[![Build Status](https://travis-ci.org/tomharvey/pwinty3-rb.svg?branch=master)](https://travis-ci.org/tomharvey/pwinty3-rb)
[![Gem Version](https://badge.fury.io/rb/pwinty.svg)](https://badge.fury.io/rb/pwinty)
[![Test Coverage](https://api.codeclimate.com/v1/badges/e92699eebe92f2db5758/test_coverage)](https://codeclimate.com/github/tomharvey/pwinty3-rb/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/e92699eebe92f2db5758/maintainability)](https://codeclimate.com/github/tomharvey/pwinty3-rb/maintainability)
[![Known Vulnerabilities](https://snyk.io//test/github/tomharvey/pwinty3-rb/badge.svg?targetFile=Gemfile.lock)](https://snyk.io//test/github/tomharvey/pwinty3-rb?targetFile=Gemfile.lock)


This wraps the Pwinty API at version 3 and aims to make your ruby life easier
when interacting with the API.

See http://pwinty.com and https://pwinty.com/api for more details around the
core service.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'pwinty'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pwinty

 And include in your app with `require "pwinty"`

## Configuration
You can use environment variables or you can declare the configuration in your
app.

#### Authentication
To authenticate requests you must get your merchant ID and API Key from the
[Integration Settings in the Pwinty Dashboard](https://beta-dashboard.pwinty.com/settings/integrations).

These values must be set as the Environment Variables
`PWINTY_MERCHANT_ID` and `PWINTY_API_KEY`
or declared in your app using:

``` ruby
Pwinty::MERCHANT_ID = 'your merchant id'
Pwinty::API_KEY = 'your api key'
```

#### Production vs Sandbox
The Pwinty API provides a sandbox endpoint to test and develop against at
`https://sandbox.pwinty.com`. This is the default
endpoint used by this library.

When you are ready to switch to the production endpoint, set the
Environment Variable `PWINTY_BASE_URL` or declare the
constant in your app:

``` ruby
Pwinty::BASE_URL = 'https://api.pwinty.com'  # Without a trailing slash
```

## Usage

### Create an Order

These are the minimum variables you need to send to the API to register your
order, you'll want to add more or update later.

See the `lib/pwinty/order.rb` file or the
[API documentation](https://pwinty.com/api/#orders-create)
to understand the full list of attributes to send.

``` ruby
order = Pwinty::Order.create(
    recipientName: "FirstName LastName",
    countryCode: "US",
    preferredShippingMethod: "Budget"
)
```

This create method will return a `Pwinty::Order` object.

### Get an existing Order from the API

Once an order is created you can retreive it from the API to further manage it,
or if it has been submitted you can see the latest production and shipping details.

``` ruby
order = Pwinty::Order.find(1)  # Pass the ID returned when you created the Order
```

This method will return a `Pwinty::Order` object.

### Update an Order

Using the `order` object created in the above, we can update this using:

``` ruby
order.update(
    address1: 'Street Name',
)
```

This update method will update the `Pwinty::Order` object.

### Validate an Order

Before submitting you might want to validate the order and check all is well.

``` ruby
status = order.submission_status
```

This will return a `Pwinty::OrderStatus` object. See the
[API documentation](https://pwinty.com/api/#orders-validate)
for more details of the shape of this reponse. But, you'll at least want the
`status.isValid` method for a boolean
check to see if it can be submitted.

### Add an Image to your Order

Add a single image by passing a hash to:

``` ruby
order.add_image(
	sku: "GLOBAL-PHO-4X6-PRO",
	url: "http://example.com/mytestphoto.jpg",
	copies: 1,
)
```

or you can add multiple images by passing a list of hashes to the pluralised method:

``` ruby
order.add_images([
	{
		sku: "GLOBAL-PHO-4X6-PRO",
		url: "http://example.com/myTestPhoto.jpg",
		copies: 1,
	}, {
		sku: "GLOBAL-PHO-10X12-PRO",
		url: "http://example.com/myLargeTestPhoto.jpg",
		copies: 1,
	}
])
```

On completion there will be a list of `Pwinty::Image` objects associated with `order.images`


### Submit, Cancel or Hold an order

Before you submit you should run Validate and ensure there are no errors.

``` ruby
order.submit
>>> true

order.cancel
>>> true

order.hold
>>> true
```

These methods will either submit your order for processing, or cancel/hold the
processing. Each will return a boolean.

### Check the shipment status of a submitted Order

Once created you can use the `find` method to get the most up to date info about an Order.
Following submission, this will contain a shippingInfo with a price for shipping and 
a list of `Pwinty::Shipment` objects

``` ruby
order = Pwinty::Order.find(1)
order.shippingInfo.price
>>> 500

order.shippingInfo.shipments[0]
>>> #<Pwinty::Shipment shipmentId="1" isTracked=true trackingNumber="XYZ123456ABC" ...
```

### List your orders

``` ruby
orders = Pwinty::Order.list
```
**N.B - This will get all of your orders - this can take some time. By default, it will request the orders from Pwinty in batches of 50; so 500 orders will take 10 requests to complete.** 

Will return an array of `Pwinty::Order` objects.

### Count your orders

``` ruby
count = Pwinty::Order.count
```
Will return an integer of the number of orders you have.



## Development

After checking out the repo, run `bundle` to install dependencies.

Then, run `rake` to run the tests.

You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

The tests use VCRs to mock the responses from Pwinty's API. See the
spec/vcrs directory for some example responses from the Pwinty API
which are used in the existing tests.

To install this gem onto your local machine, run `bundle exec rake install`.

You can create a `.env` file based on the provided `.env.sample` to hold your Pwinty sandbox credentials.

#### For project owners only:
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/tomharvey/pwinty3-rb/issues. This project is intended to be
a safe, welcoming space for collaboration, and contributors are expected to
adhere to the [Contributor Covenant](http://contributor-covenant.org)
code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pwinty project’s codebases, issue trackers, chat
rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/tomharvey/pwinty3-rb/blob/master/CODE_OF_CONDUCT.md).
