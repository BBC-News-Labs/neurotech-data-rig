Given(/^I am viewing the sensor data page$/) do
  visit "/sensor_data"
  sleep 2 #Give faye time to subscribe
end

Given(/^the test subject is watching a video$/) do
  test_client = TestMessagingClient.new
  test_client.send_message("videoPlaybackStarted:1418123530:1980_2Ronnies.mp4")
  sleep 2 #Make sure we can receive the messages
  test_client.finalize
end

When(/^the test subject focuses on an area of the video$/) do
  test_client = TestMessagingClient.new
  test_client.send_message("eyeTrackingFixation:1418123609:10:100:200")
  sleep 2 #Make sure we can receive the messages
  test_client.finalize
end

Then(/^I should see the playing video$/) do
  expect(page).to have_selector("video source[src='/video/1980_2Ronnies.mp4']")
end

Then(/^I should see the fixation point displayed on my screen$/) do
  expect(page).to have_selector("svg circle[cx='100'][cy='200']")
end
