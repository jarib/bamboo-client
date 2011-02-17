module Bamboo
  module Client
    module Http
      class Abstract
        attr_reader :uri

        def initialize(url)
          @uri = URI.parse url
        end

        private

        def uri_for(uri_or_path, params = nil)
          if uri_or_path.kind_of? URI
            u = uri_or_path.dup

            u.host   = @uri.host
            u.port   = @uri.port
            u.scheme = @uri.scheme
          else
            u = uri.dup
            u.path = uri_or_path
          end

          u.query = query_string_for(params) if params
          u.to_s
        end

        def query_string_for(params)
          params.map { |k, v| "#{k.to_s}=#{CGI.escape(v.to_s)}" }.join('&')
        end

      end # Abstract
    end # Http
  end # Client
end # Bamboo
