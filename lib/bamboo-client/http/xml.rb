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
            assert_no_error
          end

          def text_for(css)
            @doc.css(css).text
          end

          def objects_for(selector, klass, *extra_args)
            @doc.css(selector).map { |e| klass.new(e, *extra_args) }
          end

          def object_for(selector, klass, *extra_args)
            node = @doc.css(selector).first
            node or raise Error, "no node matches selector #{selector.inspect}"

            klass.new node, *extra_args
          end

          private

          def assert_no_error
            errors = @doc.css("errors error").map { |e| e.text }
            unless errors.empty?
              raise Error, "#{errors.join ' '}"
            end
          end
        end # Doc

        def post(path, data = {})
          resp = RestClient.post(uri_for(path), data) do |response, request, result, &block|
            if [301, 302, 307].include? response.code
              response.follow_redirection(request, result, &block)
            else
              response.return!(request, result, &block)
            end
          end

          Doc.from resp
        end

      end # Xml
    end # Http
  end # Client
end # Bamboo
