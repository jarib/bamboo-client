Feature: Bamboo Remote client
  In order to know more about our build pipeline
  As a Bamboo user
  I want to use Bamboo's Remote API

  Background:
    Given I am using the Remote client

  Scenario: Fetch build names
    Given I am logged in
    When I fetch all build names
    Then I should get a list of builds
