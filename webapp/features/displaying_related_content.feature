Feature: Displaying related content to test subjects
  In order to help subjects with improving and maintaining their memory
  When a subject has finished watching a video
  Then the system should display content from around the web related to the topics of interest identified by the system

  Background:
    Given I am viewing the related content page
    When the video finishes playing


  Scenario: A test subject sees a wikipedia link about the given topic
    Then I should see a link to the wikipedia page about the given topic

  Scenario: A test subject sees archive news articles related to a topic
    Then I should see a link to a news article about the given topic

  Scenario: A test subject sees images related to a topic
    Then I should see an image related to the given topic

  Scenario: A test subject sees YouTube videos related to a topic
    Then I should see a youtube video related to the given topic

  Scenario: A test subject sees wikipedia articles about other topics related to the given topic
    Then I should see a link to a wikipedia page about another topic related to the given topic
