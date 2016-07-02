require "sinatra"
require "json"
require_relative "config"
require_relative "models/host"
require_relative "lib/report"

set :show_exceptions, :after_handler

if ENV["AUTH_USERNAME"].to_s != ""
  use Rack::Auth::Basic do |username, password|
    username == ENV["AUTH_USERNAME"] && password == ENV["AUTH_PASSWORD"]
  end
end

post '/report/:name' do |name|
  name.gsub!(/[^a-zA-Z0-9\.\-_]/, '')
  host = Host[name: name] || Host.create(name: name)

  request.body.rewind
  packages = request.body.read.chomp("").split("\n").reject {|l| l.nil? || l == "" }.sort
  (report = Report.new(host, packages)).save

  render_json({ uploaded: packages.size, changed: report.changes.size })
end

get "/" do
  @hosts = Host.order(:name)
  erb :hosts
end

get "/hosts" do
  render_json(Host.order(:name).map(&:as_json))
end

error Sequel::DatabaseError do
  render_json({ error: "Database problem: #{env["sinatra.error"].message}" }, 500)
end

def render_json(data, status = 200)
  [ status, { "Content-type" => "application/json" }, data.to_json ]
end
