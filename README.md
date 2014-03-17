# ruby-mpns

A ruby gem to communicate with Microsoft Push Notification Service.

## Installing

From the commande line:

`gem install ruby-mpns`

Or in your gemfile:

`gem 'ruby-mpns'`

## Usage

To use it just use the singleton `MicrosoftPushNotificationService` like the following:

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
				<subtree>
					<subkey>value</subkey>
				</subtree>
		</root>

### Tile notification

The following notification parameters can be defined in the options hash for `:tile`:

* `title` - the title
* `count` - the badge to display on the app tile
* `background_image` - the path to a local image embedded in the app or an image accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
* `back_title` - the title when the tile is flipped
* `back_background_image` - the path to a local image embedded in the app or an image accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
* `back_content` - the content when the tile is flipped
* `navigation_uri` _(optional)_ - the exact navigation URI for the tile to update, only needed if you wish to update a secondary tile

## Reference

For general information about Push Notification on Windows Phone check the [MSDN](http://msdn.microsoft.com/en-us/library/hh202945\(v=vs.92\).aspx).

## How to contribute ?

* Add a feature you're missing or pick up ones from the above lists.
* Do not forget to __update the unit tests__ !
* Make sure the tests runs using `bundle exec rake test` in the project's root directory.

### Missing features

* Support HTTPS
* Support sending raw notification data in other formats like text, bytes or JSON
* Add an ActiveRecord extension (acts_as_microsoft_pushable)

### Contributors

* [Dmitry Medvinsky](https://github.com/dmedvinsky)
* [Sergio Campama](https://github.com/sergiocampama)
* [Dombi Attila](https://github.com/dombesz)

## License

Copyright (c) 2012-now [Nicolas VERINAUD](http://www.nverinaud.com). Released under the MIT license.


