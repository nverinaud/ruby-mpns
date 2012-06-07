require "htmlentities"
require "net/http"
require "uri"

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
    type = safe_type_to_sym type
    header = self.http_header_for_type type

    notification = nil
    notification_class = nil

    if type == :tile
      notification = tile_notification_with_options options
      notification_class = "1"
    elsif type == :toast
      notification = toast_notification_with_options options
      notification_class = "2"
    else
      notification = raw_notification_with_options options
      notification_class = "3"
    end

    # HTTP connection
    uri = URI.parse(self.device_uri)

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.content_type = "text/xml"

    if type.to_sym != :raw
      request["X-WindowsPhone-Target"] = type.to_s
    end
    request["X-NotificationClass"] = notification_class
    request.body = notification
    request.content_length = notification.length
    
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end

    return response
  end


protected

  def safe_type_to_sym type
    sym = nil

    unless type.nil?
      sym = type.to_sym
    else
      sym = :raw
    end

    if sym != :tile && sym != :toast
      sym = :raw
    end

    return sym
  end

  def http_header_for_type type

    if type == :toast || type == :tile
      "X-WindowsPhone-Target:#{type.to_s}"
    end
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
    return notification
  end

  # Tile options :
  #   - title : string
  #   - background_image : string, path to local image embedded in the app or accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
  #   - count : integer
  #   - back_title : string
  #   - back_background_image : string, path to local image embedded in the app or accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
  #   - back_content : string
  def tile_notification_with_options options = {}
    coder = HTMLEntities.new

    notification = '<?xml version="1.0" encoding="utf-8"?>'
    notification << '<wp:Notification xmlns:wp="WPNotification">'
    notification <<   '<wp:Tile '
    notification <<     '<wp:BackgroundImage>' << coder.encode(options[:background_image]) << '</wp:BackgroundImage>'
    notification <<     '<wp:Count>' << coder.encode(options[:count]) << '</wp:Count>'
    notification <<     '<wp:Title>' << coder.encode(options[:title]) << '</wp:Title>'
    notification <<     '<wp:BackBackgroundImage>' << coder.encode(options[:back_background_image]) << '</wp:BackBackgroundImage>'
    notification <<     '<wp:BackTitle>' << coder.encode(options[:back_title]) << '</wp:BackTitle>'
    notification <<     '<wp:BackContent>' << coder.encode(options[:back_content]) << '</wp:BackContent>'
    notification <<   '</wp:Tile>'
    notification << '</wp:Notification>'
    return notification
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
    return notification
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
