require File.expand_path("../../spec_helper", __FILE__)

module Bamboo
  module Client
    describe Rest do
      let(:document) { mock(Http::Json::Doc) }
      let(:http) { mock(Http::Json) }
      let(:client) { Rest.new(http) }

      it "should be able to fetch plans" do
        document.should_receive(:expand).with("plans", Rest::Plan).and_return %w[foo bar]

        http.should_receive(:get).with(
          "/rest/api/latest/plan"
        ).and_return(document)

        plans = client.plans

        plans.should_not be_empty
        plans.should == %w[foo bar]
      end

      describe Rest::Plan do
        let(:data) { nil }
        let(:plan) { Rest::Plan.new(data)}

        it "does something" do
          plan
          pending
        end
      end


    end # Rest
  end # Client
end # Bamboo
