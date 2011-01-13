module Bamboo
  module Client
    module Http
      class Abstract
        attr_reader :uri

        def initialie(url)
          @uri = URI.parse url
        end
      end # Abstract
    end # Http
  end # Client
end # Bamboo
