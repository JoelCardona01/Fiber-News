require "test_helper"

class LikedsubmissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @likedsubmission = likedsubmissions(:one)
  end

  test "should get index" do
    get likedsubmissions_url
    assert_response :success
  end

  test "should get new" do
    get new_likedsubmission_url
    assert_response :success
  end

  test "should create likedsubmission" do
    assert_difference('Likedsubmission.count') do
      post likedsubmissions_url, params: { likedsubmission: {  } }
    end

    assert_redirected_to likedsubmission_url(Likedsubmission.last)
  end

  test "should show likedsubmission" do
    get likedsubmission_url(@likedsubmission)
    assert_response :success
  end

  test "should get edit" do
    get edit_likedsubmission_url(@likedsubmission)
    assert_response :success
  end

  test "should update likedsubmission" do
    patch likedsubmission_url(@likedsubmission), params: { likedsubmission: {  } }
    assert_redirected_to likedsubmission_url(@likedsubmission)
  end

  test "should destroy likedsubmission" do
    assert_difference('Likedsubmission.count', -1) do
      delete likedsubmission_url(@likedsubmission)
    end

    assert_redirected_to likedsubmissions_url
  end
end
