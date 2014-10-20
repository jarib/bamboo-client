require File.expand_path("../../../spec_helper", __FILE__)

module Bamboo
  module Client
    module Http
      describe Abstract do

        it 'should translate a path with prefix' do
          http = Http::Abstract.new('http://example.com/bamboo')
          http.send(:uri_for, '/foobar').should == 'http://example.com/bamboo/foobar'
        end

        it 'should translate a path without prefix' do
          http = Http::Abstract.new('http://example.com/')
          http.send(:uri_for, '/foobar').should == 'http://example.com/foobar'
        end

      end
    end
  end
end
