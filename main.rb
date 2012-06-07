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

uri = "http://sn1.notify.live.net/throttledthirdparty/01.00/AAEmUMSnjDlRRrL8_qKMTouIAgAAAAADAQAAAAQUZm52OjIzOEQ2NDJDRkI5MEVFMEQ"

MicrosoftPushNotificationService.send_notification uri, :toast, options