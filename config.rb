require "sequel"
require "sequel-pg_array"
require "dotenv"
require "slack-notifier"

Dotenv.load
DB = Sequel.connect(ENV["DATABASE_URL"])
SlackClient = ENV["SLACK_WEBHOOK_URL"].to_s != "" ? Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"], username: ENV["SLACK_USERNAME"] || "AptWatcher", icon_emoji: ENV["SLACK_ICON"] || ":newspaper:") : nil

