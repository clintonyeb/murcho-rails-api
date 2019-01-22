require 'test_helper'

class ChurchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @church = churches(:one)
  end

  test "should get index" do
    get churches, as: :json
    assert_response :success
  end

  test "should create church" do
    assert_difference('Church.count') do
      post churches, params: { church: { location: @church.location, motto: @church.motto, name: @church.name, photo: @church.photo, trash: @church.trash } }, as: :json
    end

    assert_response 201
  end

  test "should show church" do
    get churches(:two), as: :json
    assert_response :success
  end

  test "should update church" do
    patch churches(:two), params: { church: { location: @church.location, motto: @church.motto, name: @church.name, photo: @church.photo, trash: @church.trash } }, as: :json
    assert_response 200
  end

  test "should destroy church" do
    assert_difference('Church.count', -1) do
      delete churches(:two), as: :json
    end

    assert_response 204
  end
end
