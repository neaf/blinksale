require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

single_xml = File.read(File.expand_path(File.dirname(__FILE__) + "/fixtures/client_single.xml"))
collection_xml = File.read(File.expand_path(File.dirname(__FILE__) + "/fixtures/client_collection.xml"))

describe Blinksale::Clients do
  let(:service) do
    Blinksale::Service.new("test-host", "test-username", "test-password")
  end

  let(:clients) { service.clients }

  it "has proper service set" do
    clients.service.should eql(service)
  end

  describe "#collection_xml" do
    before(:each) do
      RestClient::Resource.any_instance.stubs(:get).returns(collection_xml)
    end

    it "returns xml of all invoices" do
      clients.collection_xml.should eql(collection_xml)
    end
  end

  describe "#single_xml" do
    before(:each) do
      RestClient::Resource.any_instance.stubs(:get).returns(single_xml)
    end

    it "returns xml of single invoice" do
      clients.single_xml(1).should eql(single_xml)
    end
  end

  describe "#all" do
    before(:each) do
      RestClient::Resource.any_instance.stubs(:get).returns(collection_xml)
    end

    it "returns clients collection" do
      clients.all.first.should be_an_instance_of(Blinksale::Client)
    end

    describe "clients" do
      let(:client) { clients.all.first }

      it "have proper attributes set" do
        client.name = "Haute Haute Heat"
      end
    end
  end

  describe "#get" do
    before(:each) do
      RestClient::Resource.any_instance.stubs(:get).returns(single_xml)
    end

    it "returns client instance" do
      clients.get(1).should be_an_instance_of(Blinksale::Client)
    end

    describe "client" do
      let(:client) { clients.get(1) }

      it "have proper attributes set" do
        client.name = "Haute Haute Heat"
      end
    end
  end
end
