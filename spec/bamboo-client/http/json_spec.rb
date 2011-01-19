require File.expand_path("../../../spec_helper", __FILE__)

module Bamboo
  module Client
    module Http
      describe Json do
        let(:url) { "http://example.com" }
        let(:json) { Json.new(url) }

        it "does a GET" do
          RestClient.should_receive(:get).with(
            "#{url}/", :accept => :json
            ).and_return('{"some": "data"}')

          doc = json.get "/"
          doc.should be_kind_of(Json::Doc)
        end

        it "does a POST" do
          RestClient.should_receive(:post).with(
            "#{url}/", '{"some":"data"}', :accept => :json, :content_type => :json
            ).and_return('')

          json.post("/", :some => "data").should be_nil
        end
      end

      describe Json::Doc do
        it "expands the elements for the given key into instance of the given class" do
          doc = Json::Doc.new({
            'strings' => ["foo", "bar"]
          })

          objs = doc.expand 'strings', SpecHelper::Wrapper
          objs.should_not be_empty
          objs.each { |o| o.should be_kind_of(SpecHelper::Wrapper) }
          objs.map { |o| o.obj }.should == %w[foo bar]
        end
      end

    end # Http
  end # Client
end # Bamboo
