if ENV['COVERAGE']
  raise "simplecov only works on 1.9" unless RUBY_PLATFORM >= "1.9"
  require 'simplecov'
  SimpleCov.start {
    add_filter "spec/"
  }
end

$:.unshift File.expand_path("../../lib", __FILE__)
require "bamboo-client"

module Bamboo::Client::SpecHelper
  def xml_fixture(name)
    path = File.join fixture_path("#{name}.xml")

    Nokogiri.XML File.read(path)
  end

  def fixture_path(file)
    dir = File.expand_path("../fixtures", __FILE__)

    File.join dir, file
  end

  class Wrapper
    attr_reader :obj

    def initialize(obj, *extra_args)
      @obj = obj
    end
  end
end

RSpec.configure do |c|
  c.include Bamboo::Client::SpecHelper
end