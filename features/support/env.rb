$:.unshift File.expand_path("../../../lib", __FILE__)
require "bamboo-client"

$DEBUG = false
RestClient.log = STDERR if false

module BambooClientHelper
  attr_reader :client

  def use(what)
    @client = Bamboo::Client.for what, url
  end

  def url
    fetch_env 'BAMBOO_URL'
  end

  def user
    fetch_env 'BAMBOO_USER'
  end

  def password
    fetch_env 'BAMBOO_PASSWORD'
  end

  private

  def fetch_env(var)
    ENV[var] or raise "#{var} must be set for cucumber tests"
  end
end

World(BambooClientHelper)
