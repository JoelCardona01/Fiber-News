require "application_system_test_case"

class LikedsubmissionsTest < ApplicationSystemTestCase
  setup do
    @likedsubmission = likedsubmissions(:one)
  end

  test "visiting the index" do
    visit likedsubmissions_url
    assert_selector "h1", text: "Likedsubmissions"
  end

  test "creating a Likedsubmission" do
    visit likedsubmissions_url
    click_on "New Likedsubmission"

    click_on "Create Likedsubmission"

    assert_text "Likedsubmission was successfully created"
    click_on "Back"
  end

  test "updating a Likedsubmission" do
    visit likedsubmissions_url
    click_on "Edit", match: :first

    click_on "Update Likedsubmission"

    assert_text "Likedsubmission was successfully updated"
    click_on "Back"
  end

  test "destroying a Likedsubmission" do
    visit likedsubmissions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Likedsubmission was successfully destroyed"
  end
end
