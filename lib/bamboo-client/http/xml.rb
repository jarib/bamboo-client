require 'nokogiri'

module Bamboo
  module Client
    module Http
      class Xml < Abstract
        class Doc
          def self.from(str)
            new(Nokogiri::XML(str))
          end

          def initialize(doc)
            @doc = doc
          end

          def text_for(css)
            @doc.css(css).text
          end
        end # Doc

        def post(path, data = {})
          Doc.from RestClient.post(uri_for(path), data)
        end

        private

        def uri_for(path)
          u      = uri.dup
          u.path = path

          u.to_s
        end
      end # Xml
    end # Http
  end # Client
end # Bamboo
