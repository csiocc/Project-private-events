require "application_system_test_case"

class InvitesTest < ApplicationSystemTestCase
  setup do
    @invite = invites(:one)
  end

  test "visiting the index" do
    visit invites_url
    assert_selector "h1", text: "Invites"
  end

  test "should create invite" do
    visit invites_url
    click_on "New invite"

    fill_in "Answer", with: @invite.answer
    fill_in "Body", with: @invite.body
    fill_in "Title", with: @invite.title
    click_on "Create Invite"

    assert_text "Invite was successfully created"
    click_on "Back"
  end

  test "should update Invite" do
    visit invite_url(@invite)
    click_on "Edit this invite", match: :first

    fill_in "Answer", with: @invite.answer
    fill_in "Body", with: @invite.body
    fill_in "Title", with: @invite.title
    click_on "Update Invite"

    assert_text "Invite was successfully updated"
    click_on "Back"
  end

  test "should destroy Invite" do
    visit invite_url(@invite)
    click_on "Destroy this invite", match: :first

    assert_text "Invite was successfully destroyed"
  end
end
