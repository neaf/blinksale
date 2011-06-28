require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

single_xml = File.read(File.expand_path(File.dirname(__FILE__) + "/fixtures/invoice_single.xml"))
collection_xml = File.read(File.expand_path(File.dirname(__FILE__) + "/fixtures/invoice_collection.xml"))

describe Blinksale::Invoices do
  let(:service) do
    Blinksale::Service.new("test-host", "test-username", "test-password")
  end

  let(:invoices) { service.invoices }

  it "has proper service set" do
    invoices.service.should eql(service)
  end

  describe "#all" do
    before(:each) do
      RestClient::Resource.any_instance.stubs(:get).returns(collection_xml)
    end

    it "returns invoices collection" do
      invoices.all.first.should be_an_instance_of(Blinksale::Invoice)
    end

    describe "invoices" do
      let(:invoice) { invoices.all.first }

      it "have proper attributes set" do
        invoice.number = "100001"
        invoice.issued_on = Date.new(2006, 9, 19)
      end
    end
  end

  describe "#get" do
    before(:each) do
      RestClient::Resource.any_instance.stubs(:get).returns(single_xml)
    end

    it "returns invoice instance" do
      invoices.get(1).should be_an_instance_of(Blinksale::Invoice)
    end

    describe "invoice" do
      let(:invoice) { invoices.get(1) }

      it "have proper attributes set" do
        invoice.number = "100001"
        invoice.issued_on = Date.new(2006, 9, 19)
      end
    end
  end
end
