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

    if type == :tile
      notification = tile_notification_with_options options
    elsif type == :toast
      notification = toast_notification_with_options options
    else
      notification = raw_notification_with_options
    end

    puts notification

    # HTTP stuff here
    # uri + header + notification (xml)
    uri = URI.parse(self.device_uri)

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.content_type = "text/xml"
    request["X-WindowsPhone-Target"] = type.to_s
    request.body = notification
        
  end

  # Class Properties

  def self.default_notification_type
    @@default_notification_type
  end

  def self.default_notification_type= type
    @@default_notification_type = type.to_sym
  end

  self.default_notification_type = :toast # can also be :tile or :raw


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

    # string toastMessage = 
    #       "<wp:Notification xmlns:wp=\"WPNotification\">" +
    #           "<wp:Toast>" +
    #               "<wp:Text1><string></wp:Text1>" +
    #               "<wp:Text2><string></wp:Text2>" +
    #               "<wp:Param><string></wp:Param>" +
    #           "</wp:Toast>" +
    #       "</wp:Notification>";
  end

  # Tile options :
  #   - title : string
  #   - background_image : string, path to local image embedded in the app or accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
  #   - count : integer
  #   - back_title : string
  #   - back_background_image : string, path to local image embedded in the app or accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
  #   - back_content : string
  def tile_notification_with_options options = {}
  end

  # Raw options :
  def raw_notification_with_options options = {}
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
