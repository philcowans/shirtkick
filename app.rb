require 'rubygems'
require 'sinatra'
require 'songkicky'
require 'cgi'

Songkicky.apikey = 'Qv89ysFBmldFIlTQ'

MAX_EVENTS = 10

get '/' do
  erb :index
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
    event_name = (event.type.downcase == 'festival') ?  event.festival.name : concert_name(event)
    event_name = event_name[0..36] + "…" if event_name.size > 36
    event.date.strftime(date_format) + ' ' + event_name
  end

  case params['sex']
  when 'm'
    product_id = '235305024306672308'
  when 'f'
    product_id = '235630985080847263'
    product_id = '235374916713328904'
  end

  username_and_year = CGI.escape("#{params['songkick_username']} #{year.to_s[2..3]}") 
  tourname = CGI.escape(params['tour_name'])
  url = "http://www.zazzle.co.uk/api/create/at-238257252519438443?"
  url += "rf=238257252519438443&ax=Linkover&pd=#{product_id}&fwd=ProductPage&ed=true&"
  url += "text1=#{tourname}&username=#{username_and_year}&dates=#{names.map {|n| CGI.escape(n)}.join("%0A")}"

  redirect url
end

def year
  params['year_filter'].to_i > 0 ? params['year_filter'].to_i : nil
end

def concert_name(event)
  event.headliners.any? ? event.headliners.first.name + ' at ' + event.venue.name : event.name 
end

def date_format
  year ? '%b %d' : '%b %d, %Y'
end
