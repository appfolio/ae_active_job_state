# AeActiveJobState

This gem use callbacks from ActiveJob to set job status and save them in ActiveRecord. It supports different states of job including pending, running, finished and failed. It also allows setting job progress and job result.

The table name is `ae_active_job_state_job_states`. It uses native JSON data type in SQL so make sure your SQL database supports that. For MySQL that means version 5.7 and later.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ae_active_job_state'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install ae_active_job_state
```

Then you need to copy the migration over

```bash
$ rails generate ae_active_job_state
```

## Upgrading

Occasionally, additional migrations may be required when updating this gem. The migration generator takes a
`since_version` flag that will take the version you are upgrading from and add any required migrations since that
version.

```bash
$ rails generate ae_active_job_state --since_version 0.1.0
```

## Usage

### Include this module in your job class

```ruby
class AlwaysPassJob < ActiveJob::Base
  include AeActiveJobState::HasJobState
  def perform(_params)
    1
  end
end
```

If you want to apply this on all job classes, you can even include it in ApplicationJob

```ruby
class ApplicationJob < ActiveJob::Base
  include AeActiveJobState::HasJobState
end

class AlwaysPassJob < ApplicationJob
  def perform(_params)
    1
  end
end
```

### Get job state ID after enqueueing

```ruby
job = AlwaysPassJob.perform_later(1)
job.job_state.id
```

### Set job progress

```ruby
class HasProgressJob < ApplicationJob
  def perform(_params)
    set_job_progress!('percent' => 20)
  end
end

job = HasProgressJob.perform_later(1)
# wait for job to execute
job.job_state.progress == { 'percent' => 20 }
```

### Set job result

```ruby
class HasResultJob < ApplicationJob
  def perform(_params)
    set_job_result!('value' => 20)
  end
end

job = HasResultJob.perform_later(1)
# wait for job to finish
job.job_state.result == { 'value' => 20 }
```

## Running test

This gem assumes MySQL running at port 3307 on IP address 127.0.0.1. The quickest way to set this up is to use docker:

`docker run -d -v /tmp/mysql_data:/var/lib/mysql --name mysql5.7 -e MYSQL_ALLOW_EMPTY_PASSWORD=true -p 3307:3306 mysql:5.7`

Then you can run rpsec `bundle exec rspec`

## Running rubocop

`bundle exec rubocop`

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
