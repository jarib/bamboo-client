require File.expand_path("../../spec_helper", __FILE__)

module Bamboo
  module Client
    describe Rest do
      let(:http) { mock(Http::Json) }
      let(:client) { Rest.new(http) }

    end
  end
end
