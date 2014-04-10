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

        def post(uri_or_path, data = {})
          resp = RestClient.post(uri_for(uri_or_path), data.to_json, default_headers.merge(:content_type => :json))
          Doc.from(resp) unless resp.empty?
        end

        def post_with_query(uri_or_path, query = {})
          resp = RestClient.post(uri_for(uri_or_path, query), '{}', default_headers.merge(:content_type => :json))
          Doc.from(resp) unless resp.empty?
        end

        def get(uri_or_path, params = nil)
          uri = uri_for(uri_or_path, params)
          puts "Json.get: url: #{uri} cookies: #{cookies}" if $DEBUG
          Doc.from RestClient.get(uri, default_headers)
        end

        def get_cookies(uri_or_path, params = nil)
          uri = uri_for(uri_or_path, nil)
          resp = RestClient.get(uri, :params => params)
          @cookies = resp.cookies
        end

        private

        def default_headers
          params = { :accept => :json }
          params[:cookies] = @cookies if @cookies

          params
        end

      end # Json
    end # Http
  end # Client
end # Bamboo
