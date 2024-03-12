# Omniauth::InfinumAzure

Strategy to authenticate with Infinum AzureAD via OAuth2 in OmniAuth.

This gem is being used inside [infinum_azure-engine](https://github.com/infinum/rails-infinum-azure-engine).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-infinum_azure'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-infinum_azure

## Usage

Name of the strategy is `infinum_azure`.

Initialize omniauth inside devise:

```ruby
# config/initializers/devise.rb

config.omniauth(
  :infinum_azure,
  'InfinumAzure_client_id',
  'InfinumAzure_client_secret',
  client_options: {
    domain: 'https://login.b2c.com',
    tenant: 'InfinumAzureTenantName'
  }
)
```

When user is authenticated via omniauth, strategy will parse users info into following:

```ruby
{
  "provider" => "infinum_azure",
  "uid" => 17, # ID_OF_USER_ON_INFINUM_AZURE_SERVER
  "info" =>
  {
    "email" => 'mirko.mirkec@infinum.hr',
    "name" => 'Mirko Mirkec'
  }
}
```

Lastly, callback method should be created with same name as strategy, in this case `infinum_azure`, inside `OmniauthCallbackController`. In this method user should be authenticated and signed in.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/infinum/ruby-infinum-azure-omniauth. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Omniauth::InfinumAzure project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/infinum/ruby-infinum-azure-omniauth/blob/master/CODE_OF_CONDUCT.md).
