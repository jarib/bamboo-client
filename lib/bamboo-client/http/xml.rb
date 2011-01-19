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
            puts doc.to_s if $DEBUG
          end

          def text_for(css)
            @doc.css(css).text
          end

          def objects_for(selector, klass)
            @doc.css(selector).map { |e| klass.new(e) }
          end

          def object_for(selector, klass)
            node = @doc.css(selector).first
            node or raise Error, "no node matches selector #{selector.inspect}"

            klass.new node
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
