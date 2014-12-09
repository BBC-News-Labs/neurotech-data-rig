Feature: Visualising eye tracking data
  In order to better understand a test subject's memory and recall
  And in order to demonstrate the workings of the system
  While a subject is watching a video
  Then the system should display the fixation points from the eye-tracking sensors in real-time.

  Background:
    Given I am viewing the sensor data page
    And the test subject is watching a video

  Scenario: The video plays back synchronously with the test rig
    Then I should see the playing video 

  Scenario: Fixation points appear as overlays on the video
    When the test subject focuses on an area of the video
    Then I should see the fixation point displayed on my screen
