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

When /^I fetch all results$/ do
  @results = client.results
end

Then /^I should get a list of results$/ do
  @results.should_not be_empty
  @results.each { |result| result.should be_kind_of(Bamboo::Client::Rest::Result) }
end

Then /^all results should have a state$/ do
  @results.each { |r| [:successful, :failed].should include(r.state) }
end

When /^I log in$/ do
  client.login user, password
end

Then /^I should get a session ID$/ do
  client.cookies.has_key? :JSESSIONID
end

When /^I fetch results for a specific plan$/ do
  key = client.plans.first.key
  @results = client.results_for key
end