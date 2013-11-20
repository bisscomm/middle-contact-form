require 'sinatra'
require 'pony'
require 'json'
require 'sinatra/cross_origin'

use Rack::Protection::HttpOrigin, origin_whitelist: ["http://localhost:4567", ENV['website_url']] # /!\ http://0.0.0.0:4567/ won't be working -> usefull for testing this protection behaviour :)

configure do
  enable :cross_origin
end

set :allow_origin, :any

Pony.options = {
  :via => :smtp,
  :via_options => {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
}

get '/' do
end

post '/' do
  
  body  = params[:message]
  body += "\n\nTel: #{params[:phone]}"

  content_type :json
  
  begin
    Pony.mail :to => ENV['email_recipients'],
              :from => "\"#{params[:name]}\" <#{params[:email]}>",
              :subject => ENV['email_subject'],
              :body => body
    
    { "success" => 1 }.to_json
  rescue
    { "success" => 0, "errors" => {"sending" => "An error occurred while sending your message. Please try again later."} }.to_json
  end
end
