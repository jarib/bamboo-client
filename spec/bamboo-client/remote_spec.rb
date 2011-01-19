require File.expand_path("../../spec_helper", __FILE__)

module Bamboo
  module Client
    describe Remote do
      let(:url)  { "http://bamboo.example.com" }
      let(:http) { mock(Http::Xml) }
      let(:client) { Remote.new(http) }
      let(:document) { mock(Http::Xml::Doc) }

      context "authorization" do
        it "logs in" do
          document.should_receive(:text_for).with("response auth").and_return "token"

          http.should_receive(:post).with(
            "/api/rest/login.action",
            :username => "user",
            :password => "pass"
          ).and_return(document)

          client.login "user", "pass"
          client.token.should == "token"
        end

        it "raises an error if no token is set" do
          lambda { client.builds }.should raise_error
        end

        it "logs out" do
          http.should_receive(:post).with(
            "/api/rest/logout.action",
            :token => "foo"
          )

          client.instance_variable_set "@token", "foo"
          client.logout
          client.token.should be_nil
        end
      end

      context "API calls" do
        before { client.stub(:token => "fake-token") }

        it "updates and builds" do
          document.should_receive(:text_for).with("response success").and_return "true"

          http.should_receive(:post).
               with("/api/rest/updateAndBuild.action", :buildName => "fake-name").
               and_return(document)

          client.update_and_build("fake-name").should == "true"
        end

        it "executes a build" do
          document.should_receive(:text_for).with("response string").and_return "true"

          http.should_receive(:post).with(
            "/api/rest/executeBuild.action",
            :auth     => "fake-token",
            :buildKey => "fake-build-key"
          ).and_return(document)

          client.execute_build("fake-build-key").should == "true"
        end

        it "fetches a list of builds" do
          document.should_receive(:objects_for).with("build", Remote::Build).
                                                and_return(["some", "objects"])

          http.should_receive(:post).with(
            "/api/rest/listBuildNames.action",
            :auth => "fake-token"
          ).and_return(document)

          client.builds.should == ["some", "objects"]
        end

        it "fetches a list of the latest builds for the given user" do
          document.should_receive(:objects_for).with("build", Remote::Build).
                                                and_return(["some", "objects"])

          user = "fake-user"

          http.should_receive(:post).with(
            "/api/rest/getLatestUserBuilds.action",
            :auth => "fake-token",
            :user => user
          ).and_return(document)

          client.latest_builds_for(user).should == ["some", "objects"]
        end

        it "fetches the latest build results for a given key" do
          document.should_receive(:object_for).with("response", Remote::BuildResult).
                                               and_return(["some objects"])

          http.should_receive(:post).with(
            "/api/rest/getLatestBuildResults.action",
            :auth     => "fake-token",
            :buildKey => "fake-key"
          ).and_return(document)

          client.latest_build_results("fake-key").should == ["some objects"]
        end
      end # API calls

      describe Remote::Build do
        let(:build) { Remote::Build.new(xml_fixture("build").css("build").first) }

        it "should know if the build is enabled" do
          build.should be_enabled
        end

        it "should know the name of the build" do
          build.name.should == "Thrift - Default"
        end

        it "should know the key of the build" do
          build.key.should == "THRIFT-DEFAULT"
        end
      end # Remote::Build

      describe Remote::BuildResult do
        let(:result) { Remote::BuildResult.new(xml_fixture("build_result").css("response").first) }

        it "should have a key" do
          result.key.should == "ADS-DEFAULT"
        end

        it "should have a state" do
          result.state.should == :successful
        end

        it "should know if the build was successful" do
          result.should be_successful
        end
      end

    end # describe Remote
  end # Client
end # Bamboo
