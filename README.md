# Pwinty

[![Build Status](https://travis-ci.org/tomharvey/pwinty3-rb.svg?branch=master)](https://travis-ci.org/tomharvey/pwinty3-rb)
[![Gem Version](https://badge.fury.io/rb/pwinty.svg)](https://badge.fury.io/rb/pwinty)
[![Test Coverage](https://api.codeclimate.com/v1/badges/e92699eebe92f2db5758/test_coverage)](https://codeclimate.com/github/tomharvey/pwinty3-rb/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/e92699eebe92f2db5758/maintainability)](https://codeclimate.com/github/tomharvey/pwinty3-rb/maintainability)
[![Known Vulnerabilities](https://snyk.io//test/github/tomharvey/pwinty3-rb/badge.svg?targetFile=Gemfile.lock)](https://snyk.io//test/github/tomharvey/pwinty3-rb?targetFile=Gemfile.lock)


This wraps the Prodigi Pwinty API at version 4 and aims to make your ruby life easier
when interacting with the API.

See https://www.prodigi.com and https://www.prodigi.com/print-api/docs/ for more details around the
core service.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'pwinty', '~>4'
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
[Integration Settings in the Pwinty Sandbox Dashboard](https://sandbox-beta-dashboard.pwinty.com/settings/integrations).

These values must be set as the Environment Variables
`PWINTY_MERCHANT_ID` and `PWINTY_API_KEY`
or declared in your app using:

``` ruby
Pwinty::MERCHANT_ID = 'your merchant id'
Pwinty::API_KEY = 'your api key'
```

#### Production vs Sandbox
The Pwinty API provides a sandbox endpoint to test and develop against at
`https://api.sandbox.prodigi.com`. This is the default
endpoint used by this library.

When you are ready to switch to the production endpoint, set the
Environment Variable `PWINTY_BASE_URL` or declare the
constant in your app:

``` ruby
Pwinty::BASE_URL = 'https://api.prodigi.com'  # Without a trailing slash
```

## Usage

### Create and submit an Order

These are the minimum variables you need to create an order and submit it for printing.

This method will return a `Pwinty::Order` object.

See the `lib/pwinty/order.rb` file or the
[API documentation](https://www.prodigi.com/print-api/docs/reference/#create-order)
to understand the full list of attributes to send.

``` ruby
order = Pwinty::Order.new(
<<<<<<< HEAD
  shippingMethod: "Budget",
  recipient: {
    name: "Tom Harvey",
  },
  items: [
    {
      sku: "GLOBAL-PHO-4X6-PRO",
      copies: 1,
      assets: [
        {url: 'https://example.com/image.jpg'},
			],
      attributes: {finish: 'lustre'},
    },
  ]
)

submitted_order = order.submit

p submitted_order
>>> "ord_1234"
```

### Get an existing Order from the API

Once an order is created you can retreive it from the API to further manage it,
or if it has been submitted you can see the latest production and shipping details.

This method will return a `Pwinty::Order` object.

``` ruby
order = Pwinty::Order.find('ord_1234')  # Pass the ID returned when you created the Order
```


### Cancel an order

Orders which are not being processed can be cancelled.

This method will return a `Pwinty::Order` object.

See https://www.prodigi.com/print-api/docs/reference/#order-actions for more on the actions
you can take on an order and at which point in an order lifecycle you can take them.

``` ruby
order = Pwinty::Order.find('ord_1234')
cancelled_order = order.cancel
p cancelled_order.status.stage
>>> "Cancelled"
```

### Check the shipment status of a submitted Order

Once created you can use the `find` method to get the most up to date info about an Order.
Following submission, this will contain a shippingInfo with a price for shipping and 
a list of `Pwinty::Shipment` objects

``` ruby
order = Pwinty::Order.find('ord_1234')
order.shipments

order.shipments[0].dispatchDate
>>> '2022-04-29T00:00:00"
```

### List your orders

``` ruby
orders = Pwinty::Order.list
```
**N.B - This will get all of your orders - this can take some time. By default, it will request the orders from Pwinty in batches of 10; so 500 orders will take 50 requests to complete.** 

Will return an array of `Pwinty::Order` objects.


## Development

There is a VSCode devcontainer included, so reopen the repo in a devcontainer if you want
a quick way to setup your ruby environment. This defaults to using ruby v3

After checking out the repo, or opening in a devcontainer, run `bundle` to install dependencies.

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
