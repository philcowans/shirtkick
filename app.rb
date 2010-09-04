require 'rubygems'
require 'sinatra'
require 'songkicky'
require 'cgi'
require File.dirname(__FILE__)+'/tshirt'

Songkicky.apikey = 'Qv89ysFBmldFIlTQ'

MAX_EVENTS = 10

get '/new' do
  erb :new
end

post '/create' do
params.inspect
  if [params['songkick_username']].any?{|v| v.nil? || v.strip == ''}
    return erb(:new)
  end

  user = Songkicky::User.find_by_username(params['songkick_username'])
  events = user.past_events

  if year
    events = events.select {|e| e.date.year == year}
  end

  if events.size > MAX_EVENTS
    events = events.sort_by {|e| e.popularity }.reverse[0..10]
  end

  events = events.sort_by {|e| e.date }

  names = events.map do |event|
    event_name = (event.type.downcase == 'festival') ?  event.festival.name : event.headliners.first.name + ' at ' + event.venue.name
    event.date.strftime(date_format) + ' ' + event_name
  end

  username_and_year = CGI.escape("#{params['songkick_username']} #{year}") 
  tourname = CGI.escape(params['tour_name'])
  url = "http://www.zazzle.co.uk/api/create/at-238257252519438443?"
  url += "rf=238257252519438443&ax=Linkover&pd=235630985080847263&fwd=ProductPage&ed=true&"
  url += "text1=#{tourname}&username=#{username_and_year}&dates=#{names.map {|n| CGI.escape(n)}.join("%0A")}"

  redirect url
end

def year
  params['year_filter'].to_i > 0 ? params['year_filter'].to_i : nil
end

def date_format
  year ? '%b %d' : '%b %d, %Y'
end
