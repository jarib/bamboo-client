require File.expand_path("../../spec_helper", __FILE__)

module Bamboo
  describe Client do
    it "returns a client for the REST API" do
      client = Client.for "http://bamboo.com", :rest

      client.should be_kind_of(Client::Rest)
      client.uri.host.should == "bamboo.com"
    end

    it "returns a client for the Remote API" do
      client = Client.for "http://bamboo.com", :remote

      client.should be_kind_of(Client::Remote)
      client.uri.host.should == "bamboo.com"
    end
  end

end