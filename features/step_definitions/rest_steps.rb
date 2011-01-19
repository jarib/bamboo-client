When /^I fetch all the plans$/ do
  @plans = client.plans
end

Then /^I should get a list of plans$/ do
  @plans.should_not be_empty
  @plans.each { |plan| plan.should be_kind_of(Bamboo::Client::Rest::Plan) }
end

When /^I fetch all projects$/ do
  @projects = client.projects
end

Then /^I should get a list of projects$/ do
  @projects.should_not be_empty
  @projects.each { |pro| pro.should be_kind_of(Bamboo::Client::Rest::Project) }
end

Then /^all plans should have a key$/ do
  @plans.each { |e| e.key.should be_kind_of(String) }
end

Then /^all projects should have a key$/ do
  @projects.each { |e| e.key.should be_kind_of(String) }
end

