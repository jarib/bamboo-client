require File.expand_path("../../spec_helper", __FILE__)

module Bamboo
  module Client
    describe Rest do
      let(:http) { mock(Http::Json) }
      let(:document) { mock(Http::Json::Doc) }
      let(:client) { Rest.new(http) }

      it "logs in" do
        username = 'something'
        password = 'somethingelse'
        http.should_receive(:get_cookies).with(
          '/rest/api/latest/plan',
          {:os_authType => 'basic', :os_username => username, :os_password => password}).
          and_return({'JSESSIONID' => '1'})
        client.login username, password
        client.cookies.should == { :JSESSIONID => '1'}
      end

      it "should be able to fetch plans" do
        document.should_receive(:auto_expand).with(Rest::Plan, http).and_return %w[foo bar]

        http.should_receive(:get).with(
          "/rest/api/latest/plan/",
          nil,
          nil
        ).and_return(document)

        client.plans.should == %w[foo bar]
      end

      it "should be able to fetch projects" do
        document.should_receive(:auto_expand).with(Rest::Project, http).and_return %w[foo bar]

        http.should_receive(:get).with("/rest/api/latest/project/", nil, nil).
                                  and_return(document)

        client.projects.should == %w[foo bar]
      end

      it "should be able to fetch results" do
        document.should_receive(:auto_expand).with(Rest::Result, http).and_return %w[foo bar]

        http.should_receive(:get).with("/rest/api/latest/result/", nil, nil).
                                  and_return(document)

        client.results.should == %w[foo bar]
      end

      it "should be able to fetch results for a specific key" do
        document.should_receive(:auto_expand).with(Rest::Result, http).and_return %w[foo bar]

        http.should_receive(:get).with("/rest/api/latest/result/SOME-KEY", nil, nil).
                                  and_return(document)

        client.results_for("SOME-KEY").should == %w[foo bar]
      end

      it "should be able to fetch a plan for a specific key" do
        document.should_receive(:data).and_return('some' => 'data')

        http.should_receive(:get).with("/rest/api/latest/plan/SOME-KEY", nil, nil).
                                  and_return(document)

        client.plan_for("SOME-KEY").should be_kind_of(Rest::Plan)
      end

      describe Rest::Plan do
        let(:data) { json_fixture("plan") }
        let(:plan) { Rest::Plan.new data, http  }

        it "knows if the plan is enabled" do
          plan.should be_enabled
        end

        it "has a type" do
          plan.type.should == :chain
        end

        it "has a name" do
          plan.name.should == "Selenium 2 Ruby - WebDriver Remote Client Tests - Windows"
        end

        it "has a key" do
          plan.key.should == "S2RB-REMWIN"
        end

        it "has a URL" do
          plan.url.should == "http://xserve.openqa.org:8085/rest/api/latest/plan/S2RB-REMWIN"
        end

        it "can be queued" do
          http.should_receive(:cookies).and_return("some" => "cookie")
          http.should_receive(:post).with("/rest/api/latest/queue/S2RB-REMWIN", {}, {"some" => "cookie"})
          plan.queue
        end
      end # Plan

      describe Rest::Project do
        let(:data) { json_fixture("project") }
        let(:plan) { Rest::Project.new data, http  }

        it "has a name" do
          plan.name.should == "Selenium 2 Java"
        end

        it "has a key" do
          plan.key.should == "S2J"
        end

        it "has a URL" do
          plan.url.should == "http://xserve.openqa.org:8085/rest/api/latest/project/S2J"
        end
      end

      describe Rest::Result do
        let(:data) { json_fixture("result") }
        let(:result) { Rest::Result.new data, http }

        it "has a key" do
          result.key.should == "IAD-DEFAULT-5388"
        end

        it "has a plan key" do
          result.plan_key.should == "IAD-DEFAULT"
        end

        it "has a state" do
          result.state.should == :successful
        end

        it "knows if the build was successful" do
          result.should be_successful
        end

        it "has an id" do
          result.id.should == 8487295
        end

        it "has a number" do
          result.number.should == 5388
        end

        it "has a life cycle state" do
          result.life_cycle_state.should == :finished
        end

        it "has a URL" do
          result.url.should == "http://localhost:8085/rest/api/latest/result/IAD-DEFAULT-5388"
        end

        context "with details" do
          before do
            # TODO: arg/uri expectation?
            http.should_receive(:get).and_return Http::Json::Doc.new(json_fixture("result_with_changes"))
          end

          it "has a list of changes" do
            result.changes.first.should be_kind_of(Rest::Change)
          end

          it "has a build reason" do
            result.reason.should == "Code has changed"
          end

          it "has a start time" do
            result.start_time.should == Time.parse("2011-01-20T10:08:41.000+01:00")
          end
          it "has a relative date" do
            result.relative_date.should == "4 weeks ago"
            result.relative_time.should == "4 weeks ago"
          end

          it "has a failed test count" do
            result.failed_test_count.should == 0
          end

          it "has a successful test count" do
            result.successful_test_count.should == 13
          end

        end
      end

      describe Rest::Change do
        let(:data) { json_fixture("change") }
        let(:change) { Rest::Change.new data, http }

        it "has an id" do
          change.id.should == "131"
        end

        it "has a date" do
          change.date.should == Time.parse("2011-01-20T10:04:47.000+01:00")
        end

        it "has an author" do
          change.author.should == "joedev"
        end

        it "has a full name" do
          change.full_name.should == "Joe Developer"
        end

        it "has a username" do
          change.user_name.should == "joedev"
        end

        it "has a comment" do
          change.comment.should == "Fixed the config thing."
        end

        it "has a list of files" do
          change.files.first.should == {:name => "/trunk/server/src/main/resources/some-config.ini", :revision => "131"}
        end
      end


    end # Rest
  end # Client
end # Bamboo
