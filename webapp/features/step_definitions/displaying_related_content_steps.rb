Given(/^I am viewing the related content page$/) do
  visit "/related_content"
end

When(/^the video finishes playing$/) do
  test_client = TestMessagingClient.new
  test_client.send("videoPlaybackEnded:1980_2Ronnies.mp4:1980:Comedy:The Two Ronies")
  sleep 1
end

Then(/^I should see a link to the wikipedia page about the given topic$/) do
  expect(page).to have_css("a[href='http://en.wikipedia.org/wiki/The_Two_Ronnies']", :text => "The Two Ronnies")
  expect(page).to have_content("The Two Ronnies is a BBC television comedy sketch show created by Bill Cotton for the BBC, which aired on BBC1 from 1971 to 1987. It featured the double act of Ronnie Barker and Ronnie Corbett, the \"Two Ronnies\" of the title.")
end

Then(/^I should see a link to a news article about the given topic$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see an image related to the given topic$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a youtube video related to the given topic$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a link to a wikipedia page about another topic related to the given topic$/) do
  pending # express the regexp above with the code you wish you had
end
