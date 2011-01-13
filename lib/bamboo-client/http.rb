require 'restclient'

module Bamboo
  module Client
    module Http
      autoload :Json, "bamboo-client/http/json"
      autoload :Xml, "bamboo-client/http/xml"
    end
  end
end
