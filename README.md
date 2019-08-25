# Pwinty3

## THIS IS A WORK IN PROGRESS

This wraps the Pwinty API at version 3 and aims to make your ruby life easier when interacting with the API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pwinty3'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pwinty3

## Usage

### Configuration
You can use environment variables or you can declare the configuration in your app.

#### Authentication
To authenticate requests you must get your merchant ID and API Key from the
[Integration Settings in the Pwinty Dashboard](https://beta-dashboard.pwinty.com/settings/integrations).

These values must be set as the Environment Variables `PWINTY3_MERCHANT_ID` and `PWINTY3_API_KEY`
or declared in your app using:

```ruby
Pwinty3::MERCHANT_ID = 'your merchant id'
Pwinty3::API_KEY = 'your api key'
```

#### Production vs Sandbox
The Pwinty API provides a sandbox endpoint to test and develop against at `https://sandbox.pwinty.com`. This is the default
endpoint used by this library.

When you are ready to switch to the production endpoint, set the Environment Variable `PWINTY3_BASE_URL` or declare the
constant in your app:

``` ruby
Pwinty3::BASE_URL = 'https://api.pwinty.com'  # Without a trailing slash
```

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

The tests use VCRs to mock the responses from Pwinty's API.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pwinty3. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Pwinty3 project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pwinty3/blob/master/CODE_OF_CONDUCT.md).
