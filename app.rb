require 'rubygems'
require 'sinatra'
require 'songkicky'
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

  if params['year_filter']
    events = events.select {|e| e.date.year == params['year_filter'].to_i}
  end

  if events.size > MAX_EVENTS
    events = events.sort_by {|e| e.popularity }.reverse[0..10]
  end

  events = events.sort_by {|e| e.date }

  names = events.map do |event|
    event_name = (event.type.downcase == 'festival') ?  event.festival.name : event.headliners.first.name + ' ' + event.venue.name
    event.date.to_s + ' ' + event_name
  end

  @names = names

  tshirt = TShirt.image(names)

  erb :create
end
