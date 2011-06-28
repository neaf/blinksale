require 'rest-client'
require 'invoices'
require 'clients'

module Blinksale
  class Service
    attr_reader :subdomain, :username, :password, :rest_resource
    attr_reader :invoices, :clients

    def initialize(subdomain, username, password)
      @subdomain = subdomain
      @username = username
      @password = password

      @rest_resource = RestClient::Resource.new(base_url,
                                                :user => username,
                                                :password => password)

      @invoices = Blinksale::Invoices.new(self)
      @clients = Blinksale::Clients.new(self)
    end

    def base_url
      "https://#{ subdomain }.blinksale.com"
    end
  end
end
