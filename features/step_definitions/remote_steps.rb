Given /^I am using the (Remote|REST) client$/ do |api|
  use api.downcase
end

Given /^I am logged in$/ do
  client.login user, password
end

When /^I fetch all build names$/ do
  @builds = client.builds
end

Then /^I should get a list of builds$/ do
  @builds.should_not be_empty
  @builds.each { |e| e.should be_kind_of(client.class::Build)  }
end

When /^I fetch a build result$/ do
  builds = client.builds
  build_key = builds.first.key

  @build_result = client.latest_build_results(build_key)
end

Then /^the build result should have a key$/ do
  @build_result.key.should be_kind_of(String)
end

Then /^the build result should have a state$/ do
  @build_result.state.should be_kind_of(Symbol)
end

Then /^I should be able to get the latest result$/ do
  @builds.first.latest_results.should be_kind_of(Bamboo::Client::Remote::BuildResult)
end

Then /^I should be able to log out$/ do
  client.logout
end
