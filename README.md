# Omniauth FamilySearch

OmniAuth strategy for FamilySearch OAuth2 API.

There is also a [companion strategy](https://github.com/xrkhill/omniauth-familysearch-identity) for the Identity v2 API (OAuth 1.0a).

Note: FamilySearch [requires](https://familysearch.org/developers/docs/guides/authentication) web apps to use the OAuth 2 API.

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-familysearch', git: 'https://github.com/richardkmiller/omniauth-familysearch.git'
    
And then execute:

    $ bundle

## Usage

```ruby
# 
# To use with plain OmniAuth, choose one of these blocks to add to your
# initializer file, e.g. config/initializers/omniauth.rb

# For production
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :familysearch, ENV['FAMILYSEARCH_KEY'], '',
end

# For the beta server
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :familysearch, ENV['FAMILYSEARCH_KEY'], '',
    client_options: {
      site: 'https://identbeta.familysearch.org',   # for the beta server -- the oauth url
      api_site: 'https://beta.familysearch.org'     # for the beta server -- the api url
     }
end

# For the sandbox/integration server
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :familysearch, ENV['FAMILYSEARCH_KEY'], '',
    client_options: { site: 'https://integration.familysearch.org' }
end

#
# To use with Devise, you'll need something like this
# in config/initializers/devise.rb and see
# https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview

config.omniauth :familysearch, ENV['FAMILYSEARCH_KEY'], '', scope: '',
client_options: {
  site: 'https://identbeta.familysearch.org',   # for the beta server -- the oauth url
  api_site: 'https://beta.familysearch.org'     # for the beta server -- the api url
}


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

