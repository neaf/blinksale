require "nokogiri"
require "date"

module Blinksale
  class Invoice
    attr_accessor :id, :number, :total_amount, :due_amount, :issued_on, :due_on, :currency

    def self.from_node(node)
      self.new.tap do |i|
        i.id = node.attributes["uri"].content[/\d+$/].to_i
        i.number = node.xpath('xmlns:number').first.content
        i.total_amount = node.attributes["total"].content.to_f
        i.due_amount = node.attributes["total_due"].content.to_f
        i.issued_on = Date.strptime(node.xpath('xmlns:date').first.content, "%Y-%m-%d")
        i.due_on = Date.strptime(node.xpath('xmlns:terms').first.attributes["due_date"].content, "%Y-%m-%d")
        i.currency = node.xpath('xmlns:currency').first.content
      end
    end
  end

  class Invoices
    attr_reader :service

    def initialize(service)
      @service = service
    end

    def all(params = {})
      headers = {
        :content_type => "application/vnd.blinksale+xml",
        :accept => "application/vnd.blinksale+xml"
      }
      xml = service.rest_resource["invoices"].get(
        :params => params,
        :headers => headers
      )
      doc = Nokogiri::XML(xml)
      doc.xpath('//xmlns:invoice').map do |node|
        Invoice.from_node(node)
      end
    end

    def get(id, params = {})
      headers = {
        :content_type => "application/vnd.blinksale+xml",
        :accept => "application/vnd.blinksale+xml"
      }
      xml = service.rest_resource["invoices/#{ id }"].get(
        :params => params,
        :headers => headers
      )
      doc = Nokogiri::XML(xml)
      Invoice.from_node(doc.xpath('//xmlns:invoice').first)
    end
  end
end
