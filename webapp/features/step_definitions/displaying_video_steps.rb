When(/^I view the web application$/) do
  visit "/"
end

Then(/^I should see a video player with a news archive clip$/) do
  expect(page).to have_selector("video")
end

Then(/^I should be prompted to play the video$/) do
  expect(page).to have_button("Play")
end
