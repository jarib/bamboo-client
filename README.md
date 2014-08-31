# bamboo-client

Ruby clients for Bamboo's REST APIs:

* http://confluence.atlassian.com/display/BAMBOO/Bamboo+REST+APIs
* http://confluence.atlassian.com/display/BAMBOO/Bamboo+Remote+API (deprecated)

## example

```ruby
client = Bamboo::Client.for(:rest, "http://bamboo.example.com/")
client.login(user, pass) # required for some API calls

project = client.projects.first
project.key
project.url

plan = project.plans.first
plan.key
plan.enabled?

plan.queue unless plan.building?
sleep 1 until plan.building?
sleep 1 while plan.building?

result = plan.results.first
result.key
result.successful?
result.start_time
result.completed_time
result.state
# etc
```










