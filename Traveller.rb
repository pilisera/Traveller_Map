require 'sinatra'
require 'json'
require 'net/http'
require 'uri'

#use p not puts

currentLocation = 1, 1, 23, 38
range = 2

get '/' do
	worlds = jumpWorlds(currentLocation, range)

	worlds = JSON.parse(worlds)["Worlds"]

	worldHtml = ""
	
	worlds.each do |world|
		name = world["Name"]
		uwp = world["UWP"]

		worldHtml = worldHtml + "</br>" + "Name: " + name + ", UWP: " + uwp
	end
	
	
	jumpMap(currentLocation, 2) + "</br>" + worldHtml + "</br></br>" + "<a href=\"/widemap\">Click Here for a wider view</a>"
	
end

get '/widemap/?' do 
	jumpMap(currentLocation, 8)
end

def jumpMap(location, n)
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

	"<img src=#{url}/>"
end

def jumpWorlds(location, n)
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

