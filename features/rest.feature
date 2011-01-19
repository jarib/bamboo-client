Feature: Bamboo REST client
  In order to know more about our build pipeline
  As a Bamboo user
  I want to use Bamboo's REST API

  Background:
    Given I am using the REST client

  Scenario: Fetch plans
    When I fetch all the plans
    Then I should get a list of plans
    # And I should be able to get the latest result
  #
  # Scenario: Fetch a build result
  #   When I fetch a build result
  #   Then the build result should have a key
  #   And the build result should have a state
  #
  # Scenario: Log out
  #   Then I should be able to log out