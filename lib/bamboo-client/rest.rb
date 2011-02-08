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

      def builds
        get("build").auto_expand Build
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

      class Build
        def initialize(data)
          @data = data
        end

        def state
          @data.fetch('state').downcase.to_sym
        end

        def life_cycle_state
          @data.fetch("lifeCycleState").downcase.to_sym
        end

        def number
          @data['number']
        end

        def key
          @data['key']
        end

        def id
          @data['id']
        end

        def url
          @data.fetch("link")['href']
        end
      end # Build

    end # Rest
  end # Client
end # Bamboo
