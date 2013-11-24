# encoding: utf-8

require_relative '../lib/ruby-mpns'

puts "=== Sample Usage ==="

uri = "http://mpns.org"

#
# => TOAST
#
options = {
	title: "Hi there",
	content: "Testing <correct> encoding of special &éà chars.",
	params: {
		invoice_id: 2,
		state: 10.5,
		another: '"hey hey"'
	}
}

response = MicrosoftPushNotificationService.send_notification uri, :toast, options
puts response


#
# => RAW
#
options = { # Only on level is currently supported for raw notification, feel free to improve !
	anykey: "anyvalue",
	otherkey: "whynot"
}

response = MicrosoftPushNotificationService.send_notification uri, :raw, options
puts response


#
# => TILE
#
options = {
	title: "Hello World !",
	background_image: "local/hello.png",
	count: 12,
	back_title: "! dlroW olleH",
	back_background_image: "local/olleh.png",
	back_content: "! hcuoA"
}

response = MicrosoftPushNotificationService.send_notification uri, :token, options
puts response
