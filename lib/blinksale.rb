require 'rest-client'
require 'invoices'

module Blinksale
  class Client
    attr_reader :subdomain, :username, :password, :rest_resource

    def initialize(subdomain, username, password)
      @subdomain = subdomain
      @username = username
      @password = password
      @rest_resource = RestClient::Resource.new(base_url,
                                                username,
                                                password)
    end

    def base_url
      "https://#{ subdomain }.blinksale.com"
    end

    def invoices
      @invoices ||= Blinksale::Invoices.new(self)
    end
  end
end
