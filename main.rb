# encoding: utf-8

require File.dirname(__FILE__) + '/lib/microsoft_push_notification_service'

puts "=== Test ==="

options = {
	title: "Hi there",
	content: "Yay bro héhé <nice>",
	params: {
		invoice_id: 2,
		state: "waiting",
		dummy_key: "noob",
		another: '"hey hey"'
	}
}

uri = "http://mpns.microsoft.com/j7hd8-78d0-jjhra8"

MicrosoftPushNotificationService.send_notification uri, :toast, options