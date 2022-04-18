require "application_system_test_case"

class LikedcommentsTest < ApplicationSystemTestCase
  setup do
    @likedcomment = likedcomments(:one)
  end

  test "visiting the index" do
    visit likedcomments_url
    assert_selector "h1", text: "Likedcomments"
  end

  test "creating a Likedcomment" do
    visit likedcomments_url
    click_on "New Likedcomment"

    fill_in "Comment", with: @likedcomment.comment_id
    fill_in "Comments", with: @likedcomment.comments_id
    fill_in "User", with: @likedcomment.user_id
    fill_in "Users", with: @likedcomment.users_id
    click_on "Create Likedcomment"

    assert_text "Likedcomment was successfully created"
    click_on "Back"
  end

  test "updating a Likedcomment" do
    visit likedcomments_url
    click_on "Edit", match: :first

    fill_in "Comment", with: @likedcomment.comment_id
    fill_in "Comments", with: @likedcomment.comments_id
    fill_in "User", with: @likedcomment.user_id
    fill_in "Users", with: @likedcomment.users_id
    click_on "Update Likedcomment"

    assert_text "Likedcomment was successfully updated"
    click_on "Back"
  end

  test "destroying a Likedcomment" do
    visit likedcomments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Likedcomment was successfully destroyed"
  end
end
