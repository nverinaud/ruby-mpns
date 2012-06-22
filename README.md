# ruby-mpns

A ruby gem to communicate with Microsoft Push Notification Service.

## Installing

From the commande line:

`gem install ruby-mpns`

Or in your gemfile:

`gem 'ruby-mpns'`

## Usage

To use it juste use the singleton `MicrosoftPushNotificationService` like the following:

		uri = "http://my-uri.com/to/the-windows-phone-i-am-targetting"

		options = {
			title: "Hello !",
			content: "Hello Push Notification.",
			params: {
				any_data: 2,
				another_key: "Hum..."
			}
		}

		# response is an Net::HTTP object
		reponse = MicrosoftPushNotificationService.send_notification uri, :toast, options

See `sample/sample_usage.rb` for more samples.

## Parameters

### Toast notification

The following notification parameters can be defined in the options hash for `:toast`:

* `title` - the title
* `content` - the content
* `params` - a hash that will be transformed into `key1=value1&key2=value2...`

### Raw notification

You can pass whatever hash you want and an XML will be generated, like the following:

		<root>
				<key1>value1</key1>
				<key2>value2</key2>
		</root>

**Warning** Currently limited to one level, the hash must not contain another hash.

### Tile notification

The following notification parameters can be defined in the options hash for `:tile`:

* `title` - the title
* `count` - the badge to display on the app tile
* `background_image` - the path to a local image embedded in the app or an image accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
* `back_title` - the title when the tile is flipped
* `back_background_image` - the path to a local image embedded in the app or an image accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
* `back_content` - the content when the tile is flipped

## Reference

For general information about Push Notification on Windows Phone check the [MSDN](http://msdn.microsoft.com/en-us/library/hh202945\(v=vs.92\).aspx).

## Todo

* Add unit tests
* Add support for multi-level hash for raw notifications
* Make the future gem rails compatible and add an ActiveRecord extension (acts_as_microsoft_pushable)

## License

Copyright (c) 2012 [Nicolas VERINAUD](http://www.nverinaud.com). Released under the MIT license.


