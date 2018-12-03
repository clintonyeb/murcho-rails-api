require 'test_helper'

class EventInstancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_instance = event_instances(:one)
  end

  test "should get index" do
    get event_instances_url, as: :json
    assert_response :success
  end

  test "should create event_instance" do
    assert_difference('EventInstance.count') do
      post event_instances_url, params: { event_instance: { calendar_id: @event_instance.calendar_id, description: @event_instance.description, duration: @event_instance.duration, end_date: @event_instance.end_date, event_schema_id: @event_instance.event_schema_id, is_all_day: @event_instance.is_all_day, location: @event_instance.location, start_date: @event_instance.start_date, title: @event_instance.title } }, as: :json
    end

    assert_response 201
  end

  test "should show event_instance" do
    get event_instance_url(@event_instance), as: :json
    assert_response :success
  end

  test "should update event_instance" do
    patch event_instance_url(@event_instance), params: { event_instance: { calendar_id: @event_instance.calendar_id, description: @event_instance.description, duration: @event_instance.duration, end_date: @event_instance.end_date, event_schema_id: @event_instance.event_schema_id, is_all_day: @event_instance.is_all_day, location: @event_instance.location, start_date: @event_instance.start_date, title: @event_instance.title } }, as: :json
    assert_response 200
  end

  test "should destroy event_instance" do
    assert_difference('EventInstance.count', -1) do
      delete event_instance_url(@event_instance), as: :json
    end

    assert_response 204
  end
end
