require 'json'

module Bamboo
  module Client
    module Http
      class Json < Abstract
        class Doc
          def self.from(str)
            new JSON.parse(str)
          end

          def initialize(data)
            @data = data
            pp @data if $DEBUG
          end

          def auto_expand(klass)
            key_to_expand = @data.fetch('expand')

            obj = @data[key_to_expand]
            case obj
            when Hash
              if obj.has_key?('expand')
                Doc.new(obj).auto_expand(klass)
              else
                klass.new(obj)
              end
            when Array
              obj.map { |e| klass.new(e) }
            else
              raise TypeError, "don't know how to auto-expand #{obj.inspect}"
            end
          end
        end # Doc

        def post(path, data = {})
          resp = RestClient.post(uri_for(path), data.to_json, :accept => :json, :content_type => :json)
          Doc.from(resp) unless resp.empty?
        end

        def get(path)
          Doc.from RestClient.get(uri_for(path), :accept => :json)
        end

      end # Json
    end # Http
  end # Client
end # Bamboo
