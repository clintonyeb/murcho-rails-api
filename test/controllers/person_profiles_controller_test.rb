require 'test_helper'

class PersonProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person_profile = person_profiles(:one)
  end

  test "should get index" do
    get person_profiles_url, as: :json
    assert_response :success
  end

  test "should create person_profile" do
    assert_difference('PersonProfile.count') do
      post person_profiles_url, params: { person_profile: { address: @person_profile.address, date_of_birth: @person_profile.date_of_birth, gender: @person_profile.gender, person_id: @person_profile.person_id, profession: @person_profile.profession, relation_status: @person_profile.relation_status } }, as: :json
    end

    assert_response 201
  end

  test "should show person_profile" do
    get person_profile_url(@person_profile), as: :json
    assert_response :success
  end

  test "should update person_profile" do
    patch person_profile_url(@person_profile), params: { person_profile: { address: @person_profile.address, date_of_birth: @person_profile.date_of_birth, gender: @person_profile.gender, person_id: @person_profile.person_id, profession: @person_profile.profession, relation_status: @person_profile.relation_status } }, as: :json
    assert_response 200
  end

  test "should destroy person_profile" do
    assert_difference('PersonProfile.count', -1) do
      delete person_profile_url(@person_profile), as: :json
    end

    assert_response 204
  end
end
