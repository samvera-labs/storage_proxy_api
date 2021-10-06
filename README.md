# StorageProxyAPI

This gem provides a Ruby interface to the Camel-based [External Storage Proxy](https://github.com/samvera-labs/samvera-external_storage), which is a tool to provide a common interface between Hyrax applications and multiple 3rd party storage services.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'storage_proxy_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install storage_proxy_api

## Usage

Instantiate a `StorageProxyAPI::Client` to make API calls to the storage proxy.

```ruby
require 'storage_proxy_api/client'
base_url = 'http://localhost:9091' # replace this value with wherever the storage proxy is listening for requests.
client = StorageProxyAPI::Client.new(base_url: base_url)
```

Send a request to get the status of a file and see if it is currently staged.

```ruby
# The :service option is used to tell the External Storage Proxy which algorithm to use when translating
# an incoming request into the request that is forwarded on to the 3rd party storage service.
# The :external_uri option is the URI by which files are identified in the 3rd party storage service.
# TODO: Replace :service and :external_uri options with a real world example when we have one.
# The possible values for :service option should come from the External Storage Proxy.
response = client.status(service: "Example Storage Service", external_uri: "foo:bar")
response.staged? # returns true or false
```

Send a request to stage a file.

```ruby
response = client.stage(service: "Example Storage Service", external_uri: "foo:bar")
response.staged_location # returns a URI that can be used to download the file.
```

## Contributing 

If you're working on a PR for this project, create a feature branch off of `main`. 

This repository follows the [Samvera Community Code of Conduct](https://samvera.atlassian.net/wiki/spaces/samvera/pages/405212316/Code+of+Conduct) and [language recommendations](https://github.com/samvera/maintenance/blob/master/templates/CONTRIBUTING.md#language).  Please ***do not*** create a branch called `master` for this repository or as part of your pull request; the branch will either need to be removed or renamed before it can be considered for inclusion in the code base and history of this repository.
