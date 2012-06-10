# ruby-mpns

A ruby library to communicate with Microsoft Push Notification Service.

## Installing

Currently it is just a simple library.
Drop the file `lib/microsoft_push_notification_service.rb` in your project and include it with `require`.

**Warning !!**: this lib requires `htmlentities` gem to work. You find it [here](https://github.com/threedaymonk/htmlentities) 
or install it using `gem install htmlentities`.

## Usage

See `sample_usage.rb` for samples.

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

**Warning**: currently limited to one level, the hash must not contain another hash.

### Tile notification

The following notification parameters can be defined in the options hash for `:tile`:

* `title` - the title
* `count` - the badge to display on the app tile
* `background_image` - the path to a local image embedded in the app or an image accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
* `back_title` - the title when the tile is flipped
* `back_background_image` - the path to a local image embedded in the app or an image accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
* `back_content` - the content when the tile is flipped

## Reference

For general information about Push Notification on Windows Phone check the [MSDN](http://msdn.microsoft.com/en-us/library/hh202945(v=vs.92).aspx).

## Todo

* Make this lib a gem
* Add unit tests
* Add support for multi-level hash for raw notifications

Copyright (c) 2012 [Nicolas VERINAUD](http://www.nverinaud.com). Released under the MIT license.


