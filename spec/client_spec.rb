require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

collection_xml = File.read(File.expand_path(File.dirname(__FILE__) + "/fixtures/client_collection.xml"))
single_xml = File.read(File.expand_path(File.dirname(__FILE__) + "/fixtures/client_single.xml"))

describe Blinksale::Client do
  let(:service) do
    Blinksale::Service.new("test-host", "test-username", "test-password")
  end

  describe ".from_node" do
    let(:node) do
      Nokogiri::XML(collection_xml).xpath("//xmlns:client").first
    end

    it "returns Client instance" do
      Blinksale::Client.from_node(service, node).should be_an_instance_of(Blinksale::Client)
    end

    describe "client" do
      let(:client) do
        Blinksale::Client.from_node(service, node)
      end

      it "has proper attributes set" do
        client.id.should eql(1)
        client.name.should eql("Haute Haute Heat")
      end
    end
  end

  describe "#load_extended" do
    let(:client) do
      Blinksale::Client.from_node(service, Nokogiri::XML(collection_xml).xpath("//xmlns:client").first)
    end

    before(:each) do
      RestClient::Resource.any_instance.stubs(:get).returns(single_xml)
    end

    it "fetches additional client info" do
      client.load_extended
      client.address1.should eql("1234 Main Street")
      client.address2.should eql("Suite 123")
      client.city.should eql("Anytown")
      client.zip_code.should eql("70123")
      client.country.should eql("US")
      client.phone.should eql("123-555-1212")
    end
  end
end
