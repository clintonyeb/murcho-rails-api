require 'test_helper'

class PersonGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person_group = person_groups(:one)
  end

  test "should get index" do
    get person_groups_url, as: :json
    assert_response :success
  end

  test "should create person_group" do
    assert_difference('PersonGroup.count') do
      post person_groups_url, params: { person_group: { group_id: @person_group.group_id, person_id: @person_group.person_id } }, as: :json
    end

    assert_response 201
  end

  test "should show person_group" do
    get person_group_url(@person_group), as: :json
    assert_response :success
  end

  test "should update person_group" do
    patch person_group_url(@person_group), params: { person_group: { group_id: @person_group.group_id, person_id: @person_group.person_id } }, as: :json
    assert_response 200
  end

  test "should destroy person_group" do
    assert_difference('PersonGroup.count', -1) do
      delete person_group_url(@person_group), as: :json
    end

    assert_response 204
  end
end
