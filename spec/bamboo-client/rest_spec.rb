require File.expand_path("../../spec_helper", __FILE__)

module Bamboo
  module Client
    describe Rest do
      let(:document) { mock(Http::Json::Doc) }
      let(:http) { mock(Http::Json) }
      let(:client) { Rest.new(http) }

      it "should be able to fetch plans" do
        document.should_receive(:auto_expand).with(Rest::Plan).and_return %w[foo bar]

        http.should_receive(:get).with(
          "/rest/api/latest/plan"
        ).and_return(document)

        client.plans.should == %w[foo bar]
      end

      it "should be able to fetch projects" do
        document.should_receive(:auto_expand).with(Rest::Project).and_return %w[foo bar]

        http.should_receive(:get).with("/rest/api/latest/project").
                                  and_return(document)

        client.projects.should == %w[foo bar]
      end

      describe Rest::Plan do
        let(:data) { json_fixture("plan") }
        let(:plan) { Rest::Plan.new data  }

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
      end # Plan

      describe Rest::Project do
        let(:data) { json_fixture("project") }
        let(:plan) { Rest::Project.new data  }

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


    end # Rest
  end # Client
end # Bamboo
