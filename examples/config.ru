# Sample app for Viddy OAuth2 Strategy
# Make sure to setup the ENV variables VIDDY_KEY
# Run with "bundle exec rackup"

require 'rubygems'
require 'bundler'
require 'sinatra'
require 'omniauth'
require '../lib/omniauth-viddy'

# Do not use for production code.
# This is only to make setup easier when running through the sample.
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class App < Sinatra::Base
  get '/' do
    <<-HTML
    <ul>
      <li><a href='/auth/viddy'>Sign in with Viddy</a></li>
    </ul>
    HTML
  end

  get '/auth/:provider/callback' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end
  
  get '/auth/failure' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end
end

use Rack::Session::Cookie, :secret => ENV['RACK_COOKIE_SECRET']

use OmniAuth::Builder do
  # Regular usage
  provider :viddy, ENV['VIDDY_KEY']
end

run App.new
