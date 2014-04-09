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

        attr_reader :cookies

        def post(uri_or_path, data = {}, cookies = nil)
          resp = RestClient.post(uri_for(uri_or_path), data.to_json, :accept => :json, :content_type => :json, :cookies => cookies)
          Doc.from(resp) unless resp.empty?
        end

        def post_with_query(uri_or_path, query = {}, cookies = nil)
          resp = RestClient.post(uri_for(uri_or_path, query), '{}', :accept => :json, :content_type => :json, :cookies => cookies)
          Doc.from(resp) unless resp.empty?
        end

        def get(uri_or_path, params = nil, cookies = nil)
          uri = uri_for(uri_or_path, params)
          puts "Json.get: url: #{uri} cookies: #{cookies}" if $DEBUG
          Doc.from RestClient.get(uri, :accept => :json, :cookies => cookies)
        end

        def get_cookies(uri_or_path, params = nil)
          uri = uri_for(uri_or_path, nil)
          resp = RestClient.get(uri, :params => params)
          @cookies = resp.cookies
        end

      end # Json
    end # Http
  end # Client
end # Bamboo
