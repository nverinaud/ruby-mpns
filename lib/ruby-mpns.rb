require 'htmlentities'
require 'net/http'
require 'uri'

module MicrosoftPushNotificationService

  def self.extended(base)
    unless base.respond_to?(:device_uri)
      base.class.class_eval do
        attr_accessor :device_uri
      end
    end
  end

  def self.send_notification uri, type, options = {}
    device = Object.new
    device.extend MicrosoftPushNotificationService
    device.device_uri = uri
    device.send_notification type, options
  end

  def send_notification type, options = {}
    type = safe_type_to_sym(type)
    notification, notification_class = build_notification(type, options)
    uri = URI.parse(self.device_uri)

    request = Net::HTTP::Post.new(uri.request_uri)
    request.content_type = 'text/xml'
    request['X-WindowsPhone-Target'] = type.to_s if type.to_sym != :raw
    request['X-NotificationClass'] = notification_class
    request.body = notification
    request.content_length = notification.length

    Net::HTTP.start(uri.host, uri.port) { |http| http.request request }
  end


protected

  def safe_type_to_sym(type)
    sym = type.to_sym unless type.nil?
    sym = :raw unless [:tile, :toast].include?(sym)
    sym
  end

  def notification_builder_for_type(type)
    case type
    when :tile
      :tile_notification_with_options
    when :toast
      :toast_notification_with_options
    else
      :raw_notification_with_options
    end
  end

  def build_notification(type, options = {})
    notification_builder = notification_builder_for_type(type)
    send(notification_builder, options)
  end

  # Toast options :
  #   - title : string
  #   - content : string
  #   - params : hash
  def toast_notification_with_options options = {}
    coder = HTMLEntities.new

    notification = '<?xml version="1.0" encoding="utf-8"?>'
    notification << '<wp:Notification xmlns:wp="WPNotification">'
    notification <<   '<wp:Toast>'
    notification <<     '<wp:Text1>' << coder.encode(options[:title]) << '</wp:Text1>'
    notification <<     '<wp:Text2>' << coder.encode(options[:content]) << '</wp:Text2>'
    notification <<     '<wp:Param>' << coder.encode(format_params(options[:params])) << '</wp:Param>'
    notification <<   '</wp:Toast>'
    notification << '</wp:Notification>'
    return notification, '2'
  end

  # Tile options :
  #   - title : string
  #   - background_image : string, path to local image embedded in the app or accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
  #   - count : integer
  #   - back_title : string
  #   - back_background_image : string, path to local image embedded in the app or accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
  #   - back_content : string
  #   - (optional) navigation_uri : string, the exact navigation URI for the tile to update, only needed if you wish to update a secondary tile
  def tile_notification_with_options options = {}
    coder = HTMLEntities.new

    navigation_uri = options[:navigation_uri]
    tile_id = navigation_uri.nil? ? "" : 'Id="' + coder.encode(navigation_uri) + '"'

    notification = '<?xml version="1.0" encoding="utf-8"?>'
    notification << '<wp:Notification xmlns:wp="WPNotification">'
    notification <<   '<wp:Tile' << tile_id << '>'
    notification <<     '<wp:BackgroundImage>' << coder.encode(options[:background_image]) << '</wp:BackgroundImage>'
    notification <<     '<wp:Count>' << coder.encode(options[:count]) << '</wp:Count>'
    notification <<     '<wp:Title>' << coder.encode(options[:title]) << '</wp:Title>'
    notification <<     '<wp:BackBackgroundImage>' << coder.encode(options[:back_background_image]) << '</wp:BackBackgroundImage>'
    notification <<     '<wp:BackTitle>' << coder.encode(options[:back_title]) << '</wp:BackTitle>'
    notification <<     '<wp:BackContent>' << coder.encode(options[:back_content]) << '</wp:BackContent>'
    notification <<   '</wp:Tile>'
    notification << '</wp:Notification>'
    return notification, '1'
  end

  # Raw options :
  #   - raw values send like: <key>value</key>
  def raw_notification_with_options options = {}
    coder = HTMLEntities.new

    notification = '<?xml version="1.0" encoding="utf-8"?>'
    notification << '<root>'
    options.each do |key,value|
      notification <<   '<' << coder.encode(key.to_s) << '>' << coder.encode(value.to_s) << '</' << coder.encode(key.to_s) << '>'
    end
    notification << '</root>'

    return notification, '3'
  end

  def format_params params = {}
    p = "?"
    length = params.length
    count = 0
    params.each do |key,value|
      p << key.to_s << "=" << value.to_s
      count += 1
      if count < length
        p << "&"
      end
    end
    return p
  end

end
