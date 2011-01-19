module Bamboo
  module Client

    #
    # Client for the Bamboo REST API
    #
    # http://confluence.atlassian.com/display/BAMBOO/Bamboo+REST+APIs
    #

    class Rest < Abstract
      def initialize(http)
        super
        @service = "/rest/api/latest"
      end

      def plans
        get("plan").auto_expand Plan
      end

      def projects
        get("project").auto_expand Project
      end

      private

      def get(what)
        @http.get "#{@service}/#{what}"
      end

      class Plan
        def initialize(data)
          @data = data
        end

        def enabled?
          @data['enabled']
        end

        def type
          @data['type'].downcase.to_sym
        end

        def name
          @data['name']
        end

        def key
          @data['key']
        end

        def url
          @data.fetch("link")['href']
        end
      end # Plan

      class Project
        def initialize(data)
          @data = data
        end

        def name
          @data['name']
        end

        def key
          @data['key']
        end

        def url
          @data.fetch("link")['href']
        end
      end # Project

    end # Rest
  end # Client
end # Bamboo
