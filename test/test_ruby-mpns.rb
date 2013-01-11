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
    _, cls = mpns.send(:build_notification, :toast, {title: 'title', content: 'content', params: {}})
    assert_equal cls, '2'
    _, cls = mpns.send(:build_notification, :raw)
    assert_equal cls, '3'
  end
end
