require "test_helper"
require "capybara/cuprite"
# module Selenium
#   module WebDriver
#     module Chrome
#       class Driver
#         include Selenium::WebDriver::DriverExtensions::HasLogs
#       end
#     end
#   end
# end


Capybara.disable_animation = true
# Capybara.default_max_wait_time = 8
Capybara.configure do |config|
  config.test_id = "data-test"
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  options = ENV["GITHUB_WORKFLOW"] ? {
    headless: true,
    no_sandbox: true,
    disable_dev_shm_usage: true
  } : {
    headless: false
  }

  options.merge! js_errors: true

  driven_by :cuprite, using: :chromium, screen_size: [ 800, 600 ], options: options

  def fill_in(locator, with:, **options)
    sleep 0.1
    super(locator, with: with, **options)
  end

  def click_on(*args)
    sleep 0.1
    super
  end
  
  def login_as(user, password = "password")
    # visit '/session/new'

    click_on "Sign in"
    fill_in "name", with: user.name
    fill_in "password", with: password
    click_on "login"
  end
end
