require "xmlsimple"

module Blinksale
  class Invoice
    attr_accessor :id, :number, :total_amount, :due_amount, :issued_on, :due_on, :currency

    def self.from_hash(hash)
      self.new.tap do |i|
        i.id = hash["uri"][/\d+$/].to_i
        i.number = hash["number"]
        i.total_amount = hash["total"].to_f
        i.due_amount = hash["total_due"].to_f
        i.issued_on = Date.strptime(hash["date"], "%Y-%m-%d")
        i.due_on = Date.strptime(hash["terms"]["due_date"], "%Y-%m-%d")
        i.currency = hash["currency"]
      end
    end
  end

  class Invoices
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def all
      doc = XmlSimple.xml_in(client.rest_resource["invoices"].get, { "ForceArray" => ["invoice"] })
      doc["invoice"].map { |hash| Invoice.from_hash(hash) }
    end

    def get(id)
      doc = XmlSimple.xml_in(client.rest_resource["invoices/#{ id }"].get, { "ForceArray" => false })
      Invoice.from_hash(doc)
    end
  end
end
