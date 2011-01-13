require "uri"
require "restclient"

require "bamboo-client/version"
require "bamboo-client/abstract"
require "bamboo-client/rest"
require "bamboo-client/remote"

module Bamboo
  module Client
    class Error < StandardError; end

    def self.for(url, sym)
      case sym.to_sym
      when :rest
        Rest.new url
      when :remote, :legacy
        Remote.new url
      else
        raise Error, "unknown client #{sym.inspect}"
      end
    end

  end # Client
end # Bamboo
