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
        doc = get "plan"
        doc.expand "plans", Plan
      end

      private

      def get(what)
        @http.get "#{@service}/#{what}"
      end

      class Plan
        def initialize(data)
          @data = data
        end
      end

    end # Rest
  end # Client
end # Bamboo
