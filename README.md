# Omniauth FamilySearch

OmniAuth strategy for FamilySearch OAuth2 API.

There is also a [companion strategy](https://github.com/xrkhill/omniauth-familysearch-identity) for the Identity v2 API (OAuth 1.0a).

Note: FamilySearch [requires](https://familysearch.org/developers/docs/guides/authentication) web apps to use the OAuth 2 API.

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-familysearch', git: 'https://github.com/paulwhiting/omniauth-familysearch.git'
    
And then execute:

    $ bundle

You may need to fix the version of omniauth used if you get errors at runtime

    gem 'omniauth-oauth2', '~> 1.3.1'


## Usage

```ruby
# In config/initializers/omniauth.rb -- tested with rails 5
# Choose one of these blocks to add to your initializer file

# For production
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :familysearch, Rails.application.secrets.familysearch_key, '',
end

# For the beta server
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :familysearch, Rails.application.secrets.familysearch_key, '',
    :client_options => {
      site: 'https://identbeta.familysearch.org',   # for the beta server -- the oauth url
      api_site: 'https://beta.familysearch.org'     # for the beta server -- the api url
     }
end

# To use the sandbox/integration API
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :familysearch, Rails.application.secrets.familysearch_key, '',
    :client_options => { :site => 'https://integration.familysearch.org' }
end
```

## Auth Hash

Here's an example Auth Hash available in `request.env['omniauth.auth']`:

```ruby
{
  "provider" => "familysearch",
  "uid" => "MMMM-QY4Y",
  "info" => {
    "name" => "John Doe",
    "email" => "jdoe@example.com"
  },
  "credentials" => {
    "token" => "56421fc9ac",
    "secret" => "6f532ad1bb"
  },
  "extra" => {
    "access_token" => "56421fc9ac",
    "raw_info" => {
      "users" => [
        {
          "id" => "MMMM-QY4Y",
          "contactName" => "John Doe",
          "email" => "jdoe@example.com",
          "links" => {
            "self" => {
              "href" => "https://sandbox.familysearch.org/platform/users/current?access_token=abc123"
            }
          }
        }
      ]
    }
  }
}
```

## FamilySearch OAuth 2 Docs

https://familysearch.org/developers/docs/guides/oauth2

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
