require 'sinatra'
require 'slim'
require 'json'
require 'coffee-script'
require "sinatra/reloader" if development?

module Sinatra
  module Templates
    def slim(template, options={:pretty => true}, locals={})
      render :slim, template, options, locals
    end
  end
end

get '/' do
  slim :index
end

get '/filename.json' do
  `ls public/data/`.split("\n").to_json
end

get '/coffee/*.js' do |name|
  coffee name.to_sym
end

use Rack::Static, :urls => ["script", "data"], :root => "public"
