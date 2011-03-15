require 'json'

module Bamboo
  module Client
    module Http
      class Json < Abstract
        class Doc
          attr_reader :data

          def self.from(str)
            new JSON.parse(str)
          end

          def initialize(data)
            @data = data

            pp @data if $DEBUG
          end

          def doc_for(key)
            Doc.new @data.fetch(key)
          end

          def auto_expand(klass, client)
            key_to_expand = @data.fetch('expand')

            obj = @data[key_to_expand]
            case obj
            when Hash
              if obj.has_key?('expand')
                Doc.new(obj).auto_expand(klass, client)
              else
                klass.new(obj, client)
              end
            when Array
              obj.map { |e| klass.new(e, client) }
            else
              raise TypeError, "don't know how to auto-expand #{obj.inspect}"
            end
          end
        end # Doc

        def post(uri_or_path, data = {})
          resp = RestClient.post(uri_for(uri_or_path), data.to_json, :accept => :json, :content_type => :json)
          Doc.from(resp) unless resp.empty?
        end

        def get(uri_or_path, params = nil)
          uri = uri_for(uri_or_path, params)
          Doc.from RestClient.get(uri, :accept => :json)
        end

      end # Json
    end # Http
  end # Client
end # Bamboo
