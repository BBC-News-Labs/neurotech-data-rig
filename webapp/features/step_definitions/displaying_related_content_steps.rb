Given(/^I am viewing the related content page$/) do
  visit "/related_content"
  sleep 2 #Give faye time to subscribe
end

When(/^the video finishes playing$/) do
  test_client = TestMessagingClient.new
  test_client.send_message("videoPlaybackEnded:1980_2Ronnies.mp4:1980:Comedy:The Two Ronnies:0")
  sleep 2 #Make sure we can receive the messages
  test_client.finalize
end

Then(/^I should see a link to the wikipedia page about the given topic$/) do
  expect(page).to have_css("a[href='http://en.wikipedia.org/wiki/The+Two+Ronnies']", :text => "THE TWO RONNIES")
  expect(page).to have_content("The Two Ronnies is a BBC television comedy sketch show created by Bill Cotton for the BBC, which aired on BBC1 from 1971 to 1987. It featured the double...")
end

Then(/^I should see a link to a news article about the given topic$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see an image related to the given topic$/) do
  expect(page).to have_css("img[src='http://www.simplyeighties.com/resources/263521~The-Two-Ronnies-Posters.jpg']")
end

Then(/^I should see a youtube video related to the given topic$/) do
  expect(page).to have_css("iframe[src='http://www.youtube.com/embed/CLu0lg4U0GM']")
end

Then(/^I should see a link to a wikipedia page about another topic related to the given topic$/) do
  pending # express the regexp above with the code you wish you had
end
