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
        it "auto expands a one-level expansion" do
          doc = Json::Doc.new(
            "expand" => "a",
            "a" => {"some" => "data"}
          )

          doc.auto_expand(SpecHelper::Wrapper).obj.should == {"some" => "data"}
        end

        it "auto expands Arrays" do
          expected = [{"some" => "data"}, {"something" => "else"}]

          doc = Json::Doc.new(
            "expand" => "a",
            "a" => expected
          )

          actual = doc.auto_expand(SpecHelper::Wrapper).map { |e| e.obj }
          actual.should == expected
        end

        it "auto-expands the next expansion level" do
          doc = Json::Doc.new(
            "expand" => "a",
            "a" => {
              "expand" => "b",
              "b" => %w[foo bar]
            }
          )

          actual = doc.auto_expand(SpecHelper::Wrapper).map { |e| e.obj }
          actual.should == %w[foo bar]
        end

        it "raises a TypeError if an object can't be expanded" do
          doc = Json::Doc.new(
            "expand" => "a",
            "a" => 1
          )

          lambda { doc.auto_expand(SpecHelper::Wrapper) }.should raise_error(TypeError)
        end
      end

    end # Http
  end # Client
end # Bamboo
