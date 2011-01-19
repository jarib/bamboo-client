module Bamboo
  module Client
    module Http
      class Abstract
        attr_reader :uri

        def initialize(url)
          @uri = URI.parse url
        end

        private

        def uri_for(path)
          u      = uri.dup
          u.path = path

          u.to_s
        end

      end # Abstract
    end # Http
  end # Client
end # Bamboo
