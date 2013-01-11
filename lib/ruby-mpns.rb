require 'builder'
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

  # Tile options :
  #   - title : string
  #   - background_image : string, path to local image embedded in the app or accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
  #   - count : integer
  #   - back_title : string
  #   - back_background_image : string, path to local image embedded in the app or accessible via HTTP (.jpg or .png, 173x137px, max 80kb)
  #   - back_content : string
  #   - (optional) navigation_uri : string, the exact navigation URI for the tile to update, only needed if you wish to update a secondary tile
  def tile_notification_with_options options = {}
    uri = options[:navigation_uri]
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.tag!('wp:Notification', 'xmlns:wp' => 'WPNotification') do
      xml.tag!('wp:Tile', uri.nil? ? {} : {'Id' => uri}) do
        xml.tag!('wp:BackgroundImage') { xml.text!(options[:background_image] || '') }
        xml.tag!('wp:Count') { xml.text!(options[:count].to_s || '') }
        xml.tag!('wp:Title') { xml.text!(options[:title] || '') }
        xml.tag!('wp:BackBackgroundImage') { xml.text!(options[:back_background_image] || '') }
        xml.tag!('wp:BackTitle') { xml.text!(options[:back_title] || '') }
        xml.tag!('wp:BackContent') { xml.text!(options[:back_content] || '') }
      end
    end
    [xml.target!, '1']
  end

  # Toast options :
  #   - title : string
  #   - content : string
  #   - params : hash
  def toast_notification_with_options(options = {})
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.tag!('wp:Notification', 'xmlns:wp' => 'WPNotification') do
      xml.tag!('wp:Toast') do
        xml.tag!('wp:Text1') { xml.text!(options[:title] || '') }
        xml.tag!('wp:Text2') { xml.text!(options[:content] || '') }
        xml.tag!('wp:Param') { xml.text!(format_params(options[:params])) }
      end
    end
    [xml.target!, '2']
  end

  # Raw options :
  #   - raw values send like: <key>value</key>
  def raw_notification_with_options options = {}
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.root { build_hash(xml, options) }
    [xml.target!, '3']
  end

  def build_hash(xml, options)
    options.each do |k, v|
      xml.tag!(k.to_s) { v.is_a?(Hash) ? build_hash(xml, v) : xml.text!(v.to_s) }
    end
  end

  def format_params params = {}
    return '' if params.nil?
    query = params.collect { |k, v| k.to_s + '=' + v.to_s } * '&'
    '?' + query
  end

end
