Given(/^I have watched a video$/) do
  visit "/"
  @watched_video_url = page.find("#player source")["src"]
  execute_script %{
    HTMLElement.prototype["play"] = function() {};
  }
  click_button "Play"
  execute_script %{
    var player = document.getElementById("player");
    var event = document.createEvent("CustomEvent");
    event.initCustomEvent("ended", false, false, null);
    player.dispatchEvent(event);
  }
end

When(/^I view the web application$/) do
  visit "/"
end

When(/^I indicate that I remember the topic$/) do
  click_button "I remember this"
end

When(/^I indicate that I do not remember the topic$/) do
  click_button "I don't remember this"
end

Then(/^I should see a video player with a news archive clip$/) do
  expect(page).to have_selector("video")
end

Then(/^I should be prompted to play the video$/) do
  expect(page).to have_button("Play")
end

Then(/^I should be shown another video on the same topic$/) do
  new_video_url = page.find("#player source")["src"]
  expect(new_video_url.split("/")[2]).to eq(@watched_video_url.split("/")[2])
end

Then(/^I should be shown a video on a different topic$/) do
  new_video_url = page.find("#player source")["src"]
  expect(new_video_url.split("/")[2]).not_to eq(@watched_video_url.split("/")[2])
end
