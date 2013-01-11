require 'helper'

class TestRubyMpns < Test::Unit::TestCase
  should 'safely convert type to symbol' do
    mpns = Object.new.extend MicrosoftPushNotificationService
    assert_equal :raw, mpns.send(:safe_type_to_sym, nil)
    assert_equal :raw, mpns.send(:safe_type_to_sym, 'beer')
    assert_equal :raw, mpns.send(:safe_type_to_sym, 'raw')
    assert_equal :raw, mpns.send(:safe_type_to_sym, :raw)
    assert_equal :tile, mpns.send(:safe_type_to_sym, 'tile')
    assert_equal :tile, mpns.send(:safe_type_to_sym, :tile)
    assert_equal :toast, mpns.send(:safe_type_to_sym, 'toast')
    assert_equal :toast, mpns.send(:safe_type_to_sym, :toast)
  end

  should 'get correct notification builder based on type' do
    mpns = Object.new.extend MicrosoftPushNotificationService
    assert_equal :tile_notification_with_options, mpns.send(:notification_builder_for_type, :tile)
    assert_equal :toast_notification_with_options, mpns.send(:notification_builder_for_type, :toast)
    assert_equal :raw_notification_with_options, mpns.send(:notification_builder_for_type, :raw)
    assert_equal :raw_notification_with_options, mpns.send(:notification_builder_for_type, :beer)
  end

  should 'return correct notification_class' do
    mpns = Object.new.extend MicrosoftPushNotificationService
    _, cls = mpns.send(:build_notification, :tile)
    assert_equal cls, '1'
    _, cls = mpns.send(:build_notification, :toast)
    assert_equal cls, '2'
    _, cls = mpns.send(:build_notification, :raw)
    assert_equal cls, '3'
  end

  should 'format params like a boss' do
    mpns = Object.new.extend MicrosoftPushNotificationService
    q = mpns.send(:format_params, { a: 1, b: 2 })
    assert_equal q, '?a=1&b=2'
    q = mpns.send(:format_params, { phone: '+0987 654321', email: 'luke@example.com' })
    assert_equal q, '?phone=+0987 654321&email=luke@example.com'
  end

  should 'make tile XML' do
    mpns = Object.new.extend MicrosoftPushNotificationService
    xml, _ = mpns.send(:tile_notification_with_options,
                       { title: 'title', count: 1337,
                         background_image: 'bg', back_title: 'bktitle',
                         back_background_image: 'bkbg',
                         back_content: 'bkcontent',
                         navigation_uri: 'uri' })
    assert_equal xml, '<?xml version="1.0" encoding="UTF-8"?>' +
      '<wp:Notification xmlns:wp="WPNotification">' +
      '<wp:Tile Id="uri">' +
      '<wp:BackgroundImage>bg</wp:BackgroundImage>' +
      '<wp:Count>1337</wp:Count>' +
      '<wp:Title>title</wp:Title>' +
      '<wp:BackBackgroundImage>bkbg</wp:BackBackgroundImage>' +
      '<wp:BackTitle>bktitle</wp:BackTitle>' +
      '<wp:BackContent>bkcontent</wp:BackContent>' +
      '</wp:Tile>' +
      '</wp:Notification>'
  end

  should 'make toast XML' do
    mpns = Object.new.extend MicrosoftPushNotificationService
    xml, _ = mpns.send(:toast_notification_with_options,
                       { title: 'title', content: 'content', params: {} })
    assert_equal xml, '<?xml version="1.0" encoding="UTF-8"?>' +
      '<wp:Notification xmlns:wp="WPNotification">' +
      '<wp:Toast>' +
      '<wp:Text1>title</wp:Text1>' +
      '<wp:Text2>content</wp:Text2>' +
      '<wp:Param>?</wp:Param>' +
      '</wp:Toast>' +
      '</wp:Notification>'
  end

  should 'make raw XML' do
    mpns = Object.new.extend MicrosoftPushNotificationService
    xml, _ = mpns.send(:raw_notification_with_options,
                       { key1: 'val1', key2: 'val2' })
    assert_equal xml, '<?xml version="1.0" encoding="UTF-8"?>' +
      '<root>' +
      '<key1>val1</key1>' +
      '<key2>val2</key2>' +
      '</root>'
  end
end
