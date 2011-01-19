Feature: Bamboo Remote client
  In order to know more about our build pipeline
  As a Bamboo user
  I want to use Bamboo's Remote API

  Background:
    Given I am using the Remote client
    And I am logged in

  Scenario: Fetch build names
    When I fetch all build names
    Then I should get a list of builds
    And I should be able to get the latest result

  Scenario: Fetch a build result
    When I fetch a build result
    Then the build result should have a key
    And the build result should have a state