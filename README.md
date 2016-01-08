
# nearmiss-ruby

A module for using the Nearmiss REST API and generating valid [TwiML](http://www.nearmissapp.com/docs/api/). [Click here to read the full documentation.][documentation]

## Installation

To install using [Bundler][bundler] grab the latest stable version:

```ruby
gem 'nearmiss-ruby', '~> 1.0.0'
```

To manually install `nearmiss-ruby` via [Rubygems][rubygems] simply gem install:

# nearmiss-ruby

A module for using the Nearmiss REST API and generating valid [TwiML](http://www.nearmissapp.com/docs/api/). [Click here to read the full documentation.][documentation]

## Installation

To install using [Bundler][bundler] grab the latest stable version:

```ruby
gem 'nearmiss-ruby', '~> 1.0.0'
```

To manually install `nearmiss-ruby` via [Rubygems][rubygems] simply gem install:

```bash
gem install nearmiss-ruby
```

To build and install the development branch yourself from the latest source:

```bash
git clone git@github.com:nearmiss/nearmiss-ruby.git
cd nearmiss-ruby
make install
```

## Getting Started With REST

### Setup Work

``` ruby
require 'rubygems' # not necessary with ruby 1.9 but included for completeness
require 'nearmiss-ruby'

# put your own credentials here
account_sid = 'ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
auth_token = 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'

# set up a client to talk to the Nearmiss REST API
@client = Nearmiss::REST::Client.new account_sid, auth_token

# alternatively, you can preconfigure the client like so
Nearmiss.configure do |config|
  config.account_sid = account_sid
  config.auth_token = auth_token
end

# and then you can create a new client without parameters
@client = Nearmiss::REST::Client.new
```



### List Projects
You can look up a list of all projects.

``` ruby
# list calls made or received on or after May 13, 2013
@client.project_list("start_time>" => "2013-05-13") # Notice we omit the "=" in the "start_time>=" parameter because it is automatically added
```

### List Categories
You can look up a list of all defined categories.

``` ruby
# list calls made or received on or after May 13, 2013
@client.categories() # Notice we omit the "=" in the "start_time>=" parameter because it is automatically added
```



## Supported Ruby Versions

This library supports and is [tested against][travis] the following Ruby
implementations:

- Ruby 2.2.0
- Ruby 2.1.0
- Ruby 2.0.0
- Ruby 1.9.3
- [JRuby][jruby]
- [Rubinius][rubinius]

## Getting help

If you need help installing or using the library, please contact Nearmiss Support at help@nearmiss.com first. Nearmiss's Support staff are well-versed in all of the Nearmiss Helper Libraries, and usually reply within 24 hours.

If you've instead found a bug in the library or would like new features added, go ahead and open issues or pull requests against this repo!

## More Information

There are more detailed examples in the included [examples][examples]
directory. Also for those upgrading, the [upgrade guide][upgrade] is available in the [nearmiss-ruby github wiki][wiki].

```bash
gem install nearmiss-ruby
```

To build and install the development branch yourself from the latest source:

```bash
git clone git@github.com:nearmiss/nearmiss-ruby.git
cd nearmiss-ruby
make install
```

## Getting Started With REST

### Setup Work

``` ruby
require 'rubygems' # not necessary with ruby 1.9 but included for completeness
require 'nearmiss-ruby'

# put your own credentials here
account_sid = 'ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
auth_token = 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'

# set up a client to talk to the Nearmiss REST API
@client = Nearmiss::REST::Client.new account_sid, auth_token

# alternatively, you can preconfigure the client like so
Nearmiss.configure do |config|
  config.account_sid = account_sid
  config.auth_token = auth_token
end

# and then you can create a new client without parameters
@client = Nearmiss::REST::Client.new
```



### List Projects
You can look up a list of all projects.

``` ruby
# list calls made or received on or after May 13, 2013
@client.project_list("start_time>" => "2013-05-13") # Notice we omit the "=" in the "start_time>=" parameter because it is automatically added
```

### List Categories
You can look up a list of all defined categories.

``` ruby
# list calls made or received on or after May 13, 2013
@client.categories() # Notice we omit the "=" in the "start_time>=" parameter because it is automatically added
```



## Supported Ruby Versions

This library supports and is [tested against][travis] the following Ruby
implementations:

- Ruby 2.2.0
- Ruby 2.1.0
- Ruby 2.0.0
- Ruby 1.9.3
- [JRuby][jruby]
- [Rubinius][rubinius]

## Getting help

If you need help installing or using the library, please contact Nearmiss Support at help@nearmiss.com first. Nearmiss's Support staff are well-versed in all of the Nearmiss Helper Libraries, and usually reply within 24 hours.

If you've instead found a bug in the library or would like new features added, go ahead and open issues or pull requests against this repo!

## More Information

There are more detailed examples in the included [examples][examples]
directory. Also for those upgrading, the [upgrade guide][upgrade] is available in the [nearmiss-ruby github wiki][wiki].
