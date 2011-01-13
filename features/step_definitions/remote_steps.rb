Given /^I am using the (Remote|REST) client$/ do |api|
  use api.downcase
end

Given /^I am logged in$/ do
  client.login user, password
end

When /^I fetch all build names$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should get a list of builds$/ do
  pending # express the regexp above with the code you wish you had
end
