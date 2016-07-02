AptWatcher is a simple Sinatra app that helps you keep track of packages
that need updating on your servers.  

## How it works

On each server you manage you set up a daily cron job that fetches the
list of packages that need to be updated and sends that list to
AptWatcher:

```
@daily apt-get upgrade -s | grep ^Inst | awk '{ print $2,$3; }' | tr -d '[]' | curl -u user:pass --data-binary @- https://your.aptwatcher.url/report/$(hostname) &> /dev/null
```

If any packages are in that payload that weren't previously sent, a
message is sent via a Slack incoming webhook with that list of new
packages.

## Installation

The easiest way to get going is deploying to Heroku:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Otherwise, you can bundle, create your database, migrate, and run:

```
$ bundle
$ createdb aptwatcher
$ bundle exec sequel -m db/migrations postgres://localhost/aptwatcher
$ bundle exec ruby app.rb
```

## Configuration

Check the [`.env` file](/.env) for the environment variables you can use to
configure the app.

## Contributing

Please see [contributing.md](/.github/contributing.md).

## License

AptWatcher is copyright © 2016 Honeybadger Industries LLC. It is free software, and may be redistributed under the terms specified in the [LICENSE](/LICENSE) file.

## About Honeybadger

AptWatcher is maintained by the friendly crew at [Honeybadger](https://www.honeybadger.io/), an exception, performance, and uptime monitoring service for developers.
