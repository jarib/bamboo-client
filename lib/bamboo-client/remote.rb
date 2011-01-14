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

        @token = doc.text_for("response auth")
      end

      def logout
        post :logout, :token => token
        @token = nil
      end

      def update_and_build(build_name)
        doc = post :updateAndBuild, :buildName => build_name

        doc.text_for("response success")
      end

      def execute_build(build_key)
        doc = post :executeBuild,
                   :auth     => token,
                   :buildKey => build_key

        doc.text_for "response string"
      end

      def builds
        doc = post :listBuildNames, :auth => token

        doc.objects_for("build", Remote::Build)
      end

      private

      def post(action, data = {})
        @http.post "#{@service}/#{action}.action", data
      end

      #
      # types
      #

      class Build
        def initialize(doc)
          @doc = doc
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
      end

    end # Remote
  end # Client
end # Bamboo
