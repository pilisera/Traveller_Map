require 'sinatra'
require 'json'
require 'net/http'
require 'uri'
require 'haml'

current_location = 1, 1, 23, 38
range = 2

get '/' do
	worlds = jump_worlds(current_location, range)

	worlds = JSON.parse(worlds)["Worlds"]
	
	haml :main, :locals => { :img_url => jump_map(current_location, 2), :img_2_url => jump_map(current_location, 5), :world_data => worlds }	
end

get '/widemap/?' do 
	jump_map(current_location, 8)
end

def jump_map(location, n)
	# Uses the JumpMap part of the API http://www.travellermap.com/api.htm#jumpmap
	# location = array of sx, sy, hx, hy coords http://www.travellermap.com/api.htm#system_sectorhex
	# n = jump distance

	sx, sy, hx, hy = location

	url = 'http://www.travellermap.com/JumpMap.aspx?'
	sxPart = "sx=#{sx}&"
	syPart = "sy=#{sy}&"
	hxPart = "hx=#{hx}&"
	hyPart = "hy=#{hy}&"
	jumpPart = "jump=#{n}&"
	restPart = "scale=48"

	url = url + sxPart + syPart + hxPart + hyPart + jumpPart + restPart
end

def jump_worlds(location, n)
	sx, sy, hx, hy = location

	url = 'http://www.travellermap.com/JumpWorlds.aspx?'
	sxPart = "sx=#{sx}&"
	syPart = "sy=#{sy}&"
	hxPart = "hx=#{hx}&"
	hyPart = "hy=#{hy}&"
	jumpPart = "jump=#{n}&"

	url = url + sxPart + syPart + hxPart + hyPart + jumpPart
	
	uri = URI.parse(url)

	http = Net::HTTP.new(uri.host, uri.port)

	request = Net::HTTP::Get.new(uri.request_uri)

	request.add_field('Accept', 'application/json')
	
	response = http.request(request)
	
	response.body
end

