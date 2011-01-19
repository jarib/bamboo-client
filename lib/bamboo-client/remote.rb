module Bamboo
  module Client

    #
    # Client for the legacy Bamboo Remote API
    #
    # http://confluence.atlassian.com/display/BAMBOO/Bamboo+Remote+API
    #

    class Remote < Abstract
      attr_reader :token

      def initialize(http)
        super
        @service = "/api/rest"
      end

      def login(user, pass)
        doc = post :login,
                   :username => user,
                   :password => pass

        @token = doc.text_for "response auth"
      end

      def logout
        post :logout, :token => token
        @token = nil
      end

      def update_and_build(build_name)
        doc = post :updateAndBuild, :buildName => build_name

        doc.text_for "response success"
      end

      def execute_build(build_key)
        doc = post :executeBuild,
                   :auth     => token,
                   :buildKey => build_key

        doc.text_for "response string"
      end

      def builds
        doc = post :listBuildNames, :auth => token

        doc.objects_for "build", Remote::Build, self
      end

      def latest_builds_for(user)
        doc = post :getLatestUserBuilds,
                   :auth => token,
                   :user => user

        doc.objects_for "build", Remote::Build, self
      end

      def latest_build_results(build_key)
        doc = post :getLatestBuildResults,
                   :auth     => token,
                   :buildKey => build_key

        doc.object_for "response", Remote::BuildResult
      end

      def recently_completed_results_for_project(project_key)
        doc = post :getRecentlyCompletedBuildResultsForProject,
                   :auth       => token,
                   :projectKey => project_key

        doc.objects_for "build", Remote::BuildResult
      end

      def recently_completed_results_for_build(build_key)
        doc = post :getRecentlyCompletedBuildResultsForBuild,
                   :auth       => token,
                   :buildKey => build_key

        doc.objects_for "build", Remote::BuildResult
      end

      private

      def post(action, data = {})
        @http.post "#{@service}/#{action}.action", data
      end

      #
      # types
      #

      class Build
        def initialize(doc, client)
          @doc = doc
          @client = client
        end

        def enabled?
          @doc['enabled'] == 'true'
        end

        def name
          @doc.css("name").text
        end

        def key
          @doc.css("key").text
        end

        def latest_results
          @client.latest_build_results key
        end

        def execute
          @client.execute_build(key)
        end

        def update_and_build
          @client.update_and_build(key)
        end

        def recently_completed_results
          @client.recently_completed_results_for_build(key)
        end
      end

      class BuildResult
        def initialize(doc)
          @doc = doc
        end

        def key
          @doc.css("buildKey").text
        end

        def state
          @doc.css("buildState").text.downcase.gsub(/ /, '_').to_sym
        end

        def successful?
          state == :successful
        end

        def project_name
          @doc.css("projectName").text
        end

        def name
          @doc.css("buildName").text
        end

        def number
          @doc.css("buildNumber").text.to_i
        end

        def failed_test_count
          @doc.css("failedTestCount").text.to_i
        end

        def successful_test_count
          @doc.css("successfulTestCount").text.to_i
        end

        def start_time
          Time.parse @doc.css("buildTime").text
        rescue ArgumentError
          nil
        end

        def end_time
          Time.parse @doc.css("buildCompletedDate").text
        rescue ArgumentError
          nil
        end

        def duration
          @doc.css("buildDurationInSeconds").text.to_i
        end

        def duration_description
          @doc.css("buildDurationDescription").text
        end

        def relative_date
          @doc.css("buildRelativeBuildDate").text
        end

        def test_summary
          @doc.css("buildTestSummary").text
        end

        def reason
          @doc.css("buildReason").text
        end

        def commits
          @doc.css('commits commit').map { |e| Commit.new(e) }
        end

        class Commit
          def initialize(doc)
            @doc = doc
          end

          def author
            @doc['author']
          end
        end

      end
    end # Remote
  end # Client
end # Bamboo
