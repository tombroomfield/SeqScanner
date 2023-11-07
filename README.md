# seq_scanner

## seq_scanner is a testing tool for ActiveRecord to verify that your queries are using the correct indexes.

![coverage](https://raw.githubusercontent.com/tombroomfield/SeqScanner/main/coverage/coverage.svg)

## Overview

In development and test, with a small database, postgres will often use a sequence scan even when there is an index available, making it difficult to verify that your queries will use the correct indexes in production. seq_scanner is a testing tool for ActiveRecord models to verify that your queries are using the correct indexes.

### Installation

Add this line to your application's Gemfile in the test (or development) group:

```ruby
group :test do
  gem 'seq_scanner'
end
```

### Usage

```ruby
SeqScanner.scan do
  User.order(:name).first
end
```

This will do the following:

* Tell postgres to not use any sequence scans, if possible.

* Examine the query plan for the given block of code and raise an error if a sequence scan is used.

* Reset postgres to default settings.

Under these conditions, postgres will only use a sequence scan if there is no index that can be used to satisfy the query. This will raise an error if your query would not use the correct index in production.

### In tests

For rspec, you can wrap your tests in a `SeqScanner.scan` block:

```ruby
RSpec.configure do |config|
  # ...

  config.around(:each) do |example|
    SeqScanner.scan do
      example.run
    end
  end

  # ...
end
```

This will ensure that all queries in your tests have appropriate indexes.