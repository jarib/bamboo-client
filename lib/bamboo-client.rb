require "uri"
require "restclient"
require "time"

require "bamboo-client/version"
require "bamboo-client/http"
require "bamboo-client/abstract"
require "bamboo-client/rest"
require "bamboo-client/remote"

require "pp" if $DEBUG

module Bamboo
  module Client
    class Error < StandardError; end

    def self.for(sym, url)
      case sym.to_sym
      when :rest
        Rest.new Http::Json.new(url)
      when :remote, :legacy
        Remote.new Http::Xml.new(url)
      else
        raise ArgumentError, "unknown client #{sym.inspect}"
      end
    end

  end # Client
end # Bamboo
