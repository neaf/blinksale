require "nokogiri"

module Blinksale
  class Client
    attr_accessor :name, :address1, :address2, :city, :state, :zip_code, :country, :phone

    def self.from_node(node)
      self.new.tap do |i|
        i.id = node.attributes["uri"].content[/\d+$/].to_i
        i.name = node.xpath('xmlns:name').first.content
        i.address1 = node.xpath("xmlns:address1").first.content.to_f
        i.address2 = node.xpath("xmlns:address2").first.content.to_f
        i.city = node.xpath("xmlns:city").first.content.to_f
        i.state = node.xpath("xmlns:state").first.content.to_f
        i.zip_code = node.xpath("xmlns:zip").first.content.to_f
        i.country = node.xpath("xmlns:country").first.content.to_f
        i.phone = node.xpath("xmlns:phone").first.content.to_f
      end
    end
  end

  class Clients
    attr_reader :service

    def initialize(service)
      @service = service
    end

    def all(params = {})
      headers = {
        :content_type => "application/vnd.blinksale+xml",
        :accept => "application/vnd.blinksale+xml"
      }
      xml = service.rest_resource["clients"].get(
        :params => params,
        :headers => headers
      )
      doc = Nokogiri::XML(xml)
      doc.xpath('//xmlns:client').map do |node|
        Client.from_node(node)
      end
    end

    def get(id, params = {})
      headers = {
        :content_type => "application/vnd.blinksale+xml",
        :accept => "application/vnd.blinksale+xml"
      }
      xml = service.rest_resource["clients/#{ id }"].get(
        :params => params,
        :headers => headers
      )
      doc = Nokogiri::XML(xml)
      Invoice.from_node(doc.xpath('//xmlns:client').first)
    end
  end
end
