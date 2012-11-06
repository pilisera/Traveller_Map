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
	
	haml :main, :locals => { :img_url => jump_map(current_location, 2), :world_data => worlds }	
end

get '/widemap/?' do 
	haml :wide_view, :locals => { :iframe_url => iframe(current_location, 100) }
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

Scale_Factor = Math.sqrt(3) / 2

def iframe(location, scale)
	sx, sy, hx, hy = location
	
	world_x = ( sx * 32 ) + hx - 1
	world_y = ( sy * 40 ) + hy - 40

	x = world_x * Scale_Factor
	y = -world_y

	url = 'http://www.travellermap.com/iframe.htm?'
	xPart = "x=#{x}&"
	yPart = "y=#{y}&"
	sxPart = "yah_sx=#{sx}&"
	syPart = "yah_sy=#{sy}&"
	hxPart = "yah_hx=#{hx}&"
	hyPart = "yah_hy=#{hy}&"
	scalePart = "scale=#{scale}"

	url = url + xPart + yPart + sxPart + syPart + hxPart + hyPart + scalePart
end
