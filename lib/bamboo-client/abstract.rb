module Bamboo
  module Client

    class Abstract
      attr_reader :uri

      def initialize(url)
        @uri = URI.parse(url)
      end

    end # Abstract
  end # Client
end # Bamboo
