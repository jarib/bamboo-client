require File.expand_path("../../spec_helper", __FILE__)

module Bamboo
  module Client
    describe Remote do
      let(:http) { mock(Http::Json) }
      let(:client) { Remote.new(http) }

      it "logs in" do
        # expectations
        pending
        client.login "user", "pass"
      end

    end
  end
end
