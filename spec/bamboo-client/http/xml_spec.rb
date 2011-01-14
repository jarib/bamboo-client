require File.expand_path("../../../spec_helper", __FILE__)

module Bamboo
  module Client
    module Http
      describe Xml do
        let(:url) { "http://example.com" }
        let(:xml) { Xml.new(url) }

        it "does a POST" do
          RestClient.should_receive(:post).
                     with("#{url}/", :some => "data").
                     and_return("<foo><bar></bar></foo>")

          doc = xml.post("/", :some => "data")
          doc.should be_kind_of(Xml::Doc)
        end

      end

      describe Xml::Doc do
        let(:wrapped) { mock("nokogiri document") }
        let(:doc) { Xml::Doc.new(wrapped)}

        it "returns the text of the given CSS selector" do
          wrapped.should_receive(:css).
                  with("some selector").
                  and_return(mock("node", :text => "bar"))

          doc.text_for("some selector").should == "bar"
        end
      end
    end
  end
end
