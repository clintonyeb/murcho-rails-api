require 'test_helper'

class EventSchemasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_schema = event_schemas(:one)
  end

  test "should get index" do
    get event_schemas_url, as: :json
    assert_response :success
  end

  test "should create event_schema" do
    assert_difference('EventSchema.count') do
      post event_schemas_url, params: { event_schema: { calendar_id: @event_schema.calendar_id, description: @event_schema.description, duration: @event_schema.duration, end_date: @event_schema.end_date, is_all_day: @event_schema.is_all_day, is_recurring: @event_schema.is_recurring, location: @event_schema.location, recurrence: @event_schema.recurrence, start_date: @event_schema.start_date, title: @event_schema.title } }, as: :json
    end

    assert_response 201
  end

  test "should show event_schema" do
    get event_schema_url(@event_schema), as: :json
    assert_response :success
  end

  test "should update event_schema" do
    patch event_schema_url(@event_schema), params: { event_schema: { calendar_id: @event_schema.calendar_id, description: @event_schema.description, duration: @event_schema.duration, end_date: @event_schema.end_date, is_all_day: @event_schema.is_all_day, is_recurring: @event_schema.is_recurring, location: @event_schema.location, recurrence: @event_schema.recurrence, start_date: @event_schema.start_date, title: @event_schema.title } }, as: :json
    assert_response 200
  end

  test "should destroy event_schema" do
    assert_difference('EventSchema.count', -1) do
      delete event_schema_url(@event_schema), as: :json
    end

    assert_response 204
  end
end
