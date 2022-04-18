require "test_helper"

class LikedcommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @likedcomment = likedcomments(:one)
  end

  test "should get index" do
    get likedcomments_url
    assert_response :success
  end

  test "should get new" do
    get new_likedcomment_url
    assert_response :success
  end

  test "should create likedcomment" do
    assert_difference('Likedcomment.count') do
      post likedcomments_url, params: { likedcomment: { comment_id: @likedcomment.comment_id, comments_id: @likedcomment.comments_id, user_id: @likedcomment.user_id, users_id: @likedcomment.users_id } }
    end

    assert_redirected_to likedcomment_url(Likedcomment.last)
  end

  test "should show likedcomment" do
    get likedcomment_url(@likedcomment)
    assert_response :success
  end

  test "should get edit" do
    get edit_likedcomment_url(@likedcomment)
    assert_response :success
  end

  test "should update likedcomment" do
    patch likedcomment_url(@likedcomment), params: { likedcomment: { comment_id: @likedcomment.comment_id, comments_id: @likedcomment.comments_id, user_id: @likedcomment.user_id, users_id: @likedcomment.users_id } }
    assert_redirected_to likedcomment_url(@likedcomment)
  end

  test "should destroy likedcomment" do
    assert_difference('Likedcomment.count', -1) do
      delete likedcomment_url(@likedcomment)
    end

    assert_redirected_to likedcomments_url
  end
end
