require "application_system_test_case"

class SignupTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  test "can sign up, log out, change password, log in" do
    # SIGN UP
    visit "/"

    click_on "Sign up"

    fill_in "Email Address", with: "derp@derp.com"
    fill_in "Password", with: "Derpsi2"

    click_on "signup"

    assert_text "Waiting..."

    perform_enqueued_jobs

    mail = ActionMailer::Base.deliveries.last

    url = mail.body.match(/(\/email_verifications\/.*)/)[1]
    within_window open_new_window do
      visit url
      assert_text "verified"
      # page.driver.browser.close
      page.driver.browser.page.close
    end
    # switch_to_window windows.first

    assert_text "Email verified"

    click_on "close-modal"

    click_on "user"
    assert_text "derp@derp.com"
    click_on "Log out"

    assert_no_text "derp@derp.com"

    click_on "Sign up"
    click_on "Sign in"

    # # CHANGE PASSWORD
    click_on "Forgot password?"

    fill_in "email", with: "derp@derp.com"
    click_on "Send email"
    assert_text "Check your email"

    perform_enqueued_jobs

    mail = ActionMailer::Base.deliveries.last
    url = mail.body.match(/(\/password_resets\/.*)/)[1]
    visit url

    fill_in "password", with: "Newpass123"

    click_on "Save password"


    # # TRY WRONG PASSWORD
    click_on "sign_in"

    fill_in "email", with: "derp@derp.com"
    fill_in "password", with: "wrongpass"

    click_on "login"

    assert_text "Invalid email or password"


    # # TRY CORRECT PASSWORD
    fill_in "email", with: "derp@derp.com"
    fill_in "password", with: "Newpass123"
    click_on "login"
    assert_no_text "Sign up"

    click_on "user"

    # change password
    click_on "Account Settings"

    click_on "Change Password"
    click_on "Send link"

    assert_text "Check your email"
    mail = ActionMailer::Base.deliveries.last
    url = mail.body.match(/(\/password_resets\/.*)/)[1]
    visit url
    fill_in "password", with: "Newpass12345"
    click_on "Save password"

    click_on "close"

    click_on "user"
    click_on "Log out"
    assert_text "Sign up"
  end

  # test "can update profile" do
  #   visit "/"
  #   u = users(:buhrmi)

  #   original_profile_image = u.profile_image.attached? ? u.profile_image.blob.key : nil

  #   login_as(u)

  #   click_on "user"

  #   click_on "Edit Profile"

  #   attach_file "profile_image", Rails.root.join("test", "fixtures", "files", "test_image.jpg"), visible: false


  #   fill_in "name", with: "Mr Sausage", fill_options: { clear: :backspace }
  #   find("textarea").fill_in with: "I like sausages"

  #   click_on "Save Profile"
  #   assert_text "Profile updated"
  #   u.reload
  #   assert_equal u.name, "Mr Sausage"
  #   assert_equal u.description, "I like sausages"
  #   assert u.profile_image.attached?
  #   assert_not_equal original_profile_image, u.profile_image.blob.key
  # end
end
