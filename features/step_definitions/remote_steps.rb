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
  @builds.each { |e| e.should be_kind_of(Bamboo::Client::Remote::Build)  }
end
