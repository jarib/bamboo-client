Feature: Bamboo REST client
  In order to know more about our build pipeline
  As a Bamboo user
  I want to use Bamboo's REST API

  Background:
    Given I am using the REST client

  Scenario: Fetch plans
    When I fetch all the plans
    Then I should get a list of plans
    And all plans should have a key

  Scenario: Fetch projects
    When I fetch all projects
    Then I should get a list of projects
    And all projects should have a key

  Scenario: Fetch all builds
    When I fetch all builds
    Then I should get a list of builds
    And all builds should have a state
