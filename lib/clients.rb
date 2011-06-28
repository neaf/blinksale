require "nokogiri"

module Blinksale
  class Client
    attr_accessor :service
    attr_accessor :id, :name, :address1, :address2, :city, :state, :zip_code, :country, :phone

    def self.from_node(service, node)
      self.new.tap do |i|
        i.service = service
        i.id = node.attributes["uri"].content[/\d+$/].to_i
        i.name = node.xpath('xmlns:name').first.content
      end
    end

    def load_extended
      node =  Nokogiri::XML(service.clients.single_xml(id)).xpath("//xmlns:client")

      self.tap do |i|
        i.address1 = node.xpath("xmlns:address1").first.content
        i.address2 = node.xpath("xmlns:address2").first.content
        i.city = node.xpath("xmlns:city").first.content
        i.state = node.xpath("xmlns:state").first.content
        i.zip_code = node.xpath("xmlns:zip").first.content
        i.country = node.xpath("xmlns:country").first.content
        i.phone = node.xpath("xmlns:phone").first.content
      end
    end
  end

  class Clients
    attr_reader :service

    def initialize(service)
      @service = service
    end

    def collection_xml(params = {})
      headers = {
        :content_type => "application/vnd.blinksale+xml",
        :accept => "application/vnd.blinksale+xml"
      }
      xml = service.rest_resource["clients"].get(
        :params => params,
        :headers => headers
      )
    end

    def single_xml(id, params = {})
      headers = {
        :content_type => "application/vnd.blinksale+xml",
        :accept => "application/vnd.blinksale+xml"
      }
      xml = service.rest_resource["clients/#{ id }"].get(
        :params => params,
        :headers => headers
      )
    end

    def all(params = {})
      doc = Nokogiri::XML(collection_xml(params))
      doc.xpath('//xmlns:client').map do |node|
        Client.from_node(service, node)
      end
    end

    def get(id, params = {})
      doc = Nokogiri::XML(single_xml(id, params))
      Client.from_node(service, doc.xpath('//xmlns:client').first)
    end
  end
end
