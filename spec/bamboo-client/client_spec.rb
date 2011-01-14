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
  end

end