# VtigerRuby

VtigerRuby is a Ruby SDK for the Vtiger CRM API.

Official documentation of the Vtiger API can be found here:

1. [Vtiger REST API Docs](https://www.vtiger.com/docs/rest-api-for-vtiger)
2. [Vtiger Third Party Integrations](https://community.vtiger.com/help/vtigercrm/developers/third-party-app-integration.html)

## Installation

You can install this gem to your gemset.
```
gem install 'vtiger-ruby'
```

Or add it to your gemfile and run bundle install.
```
gem 'vtiger-ruby'
```

## Getting Started

* Retrieve your `Accesskey` token information from the `My Preferences` page in the CRM Web UI.
* `username` information used when signing into your instance of the CRM.
* `endpoint` url specific to your instance, eg: https://your_instance.odx.vtiger.com/restapi/v1/vtiger/default

### Creating a Client

```ruby
require 'vtiger-ruby'
```

```ruby
endpoint = ENV['VTIGER_ENDPOINT']
username = ENV['VTIGER_USERNAME']
accesskey = ENV['VTIGER_ACCESSS_KEY']
```

```ruby
client = VtigerRuby::Client.new(
  endpoint: endpoint,
  username: username,
  accesskey: accesskey
)
```

### Authentication

Vtiger API Authentication happens in two steps:

1. Request the challenge token
```ruby
client.get_challenge
```

2. Login request
```ruby
client.login
```

Alternatively, you can authenticate the client using the `connect` method.
This single method call negates the need to complete `step 1` & `step 2` listed above.
```ruby
client.connect
```

To end the session on Vtiger and disconnect the client
```ruby
client.logout
```

## Models

The SDK arranges default [Vtiger CRM Modules](https://www.vtiger.com/docs/rest-api-for-vtiger#/CRM_Modules) into `model` classes.
The model class can then be used to perform operations against the corresponding Vtiger module.

### Account

```ruby
client.account.all # Retrieves all Vtiger Account module records
```

You can also retrieve all Vtiger Account module records from the `VtigerRuby::Account` model.

```ruby
VtigerRuby::Account.class_config(client) # Configures the class with client model
VtigerRuby::Account.all # Retrieves all Vtiger Account module records
```

## Example

```ruby
require 'vtiger-ruby'

# Credential information specific to vtiger instance
endpoint = ENV['VTIGER_ENDPOINT']
username = ENV['VTIGER_USERNAME']
accesskey = ENV['VTIGER_ACCESSS_KEY']

# Initializes the VtigerRuby client
client = VtigerRuby::Client.new(
  endpoint: endpoint,
  username: username,
  accesskey: accesskey
)

# Requests Vtiger challenge token and login
client.connect

# Retrieves all account records from the Account module
accounts = client.account.all
```

## Code Status

[![Maintainability](https://api.codeclimate.com/v1/badges/25a5fa53236293d044d8/maintainability)](https://codeclimate.com/github/ymukmar/vtiger-ruby/maintainability) [![Build Status](https://travis-ci.com/ymukmar/vtiger-ruby.svg?branch=main)](https://travis-ci.com/ymukmar/vtiger-ruby)
