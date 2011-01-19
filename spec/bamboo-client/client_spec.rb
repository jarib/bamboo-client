require File.expand_path("../../spec_helper", __FILE__)

module Bamboo
  describe Client do
    it "returns a client for the REST API" do
      client = Client.for :rest, "http://bamboo.com"

      client.should be_kind_of(Client::Rest)
    end

    it "returns a client for the Remote API" do
      client = Client.for :remote, "http://bamboo.com"

      client.should be_kind_of(Client::Remote)
    end

    it "raises ArgumentError if the client is unknown" do
      lambda { Client.for :foo, "http://foo.com" }.should raise_error(ArgumentError)
    end
  end

end