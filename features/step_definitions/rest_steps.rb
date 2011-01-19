When /^I fetch all the plans$/ do
  @plans = client.plans
end

Then /^I should get a list of plans$/ do
  @plans.should_not be_empty
  @plans.each { |plan| plan.should be_instance_of(Bamboo::Client::Rest::Plan) }
end
