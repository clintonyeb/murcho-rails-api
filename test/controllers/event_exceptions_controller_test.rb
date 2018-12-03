require 'test_helper'

class EventExceptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_exception = event_exceptions(:one)
  end

  test "should get index" do
    get event_exceptions_url, as: :json
    assert_response :success
  end

  test "should create event_exception" do
    assert_difference('EventException.count') do
      post event_exceptions_url, params: { event_exception: { event_schema_id: @event_exception.event_schema_id, exception_date: @event_exception.exception_date, status: @event_exception.status } }, as: :json
    end

    assert_response 201
  end

  test "should show event_exception" do
    get event_exception_url(@event_exception), as: :json
    assert_response :success
  end

  test "should update event_exception" do
    patch event_exception_url(@event_exception), params: { event_exception: { event_schema_id: @event_exception.event_schema_id, exception_date: @event_exception.exception_date, status: @event_exception.status } }, as: :json
    assert_response 200
  end

  test "should destroy event_exception" do
    assert_difference('EventException.count', -1) do
      delete event_exception_url(@event_exception), as: :json
    end

    assert_response 204
  end
end
