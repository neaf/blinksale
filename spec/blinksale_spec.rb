require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe Blinksale::Service do
  let(:service) do
    Blinksale::Service.new("test-host", "test-username", "test-password")
  end

  describe "#base_url" do
    it "returns full url for given subdomain" do
      service.base_url.should eql("https://test-host.blinksale.com")
    end
  end

  describe "#rest_resource" do
    it "returns instantiated RestClient resource" do
      service.rest_resource.should be_an_instance_of(RestClient::Resource)
    end

    describe "resource" do
      let(:resource) { service.rest_resource }

      it "has proper credentials set" do
        resource.url.should eql(service.base_url)
        resource.options[:user].should eql("test-username")
        resource.options[:password].should eql("test-password")
      end
    end
  end

  describe "#invoices" do
    it "returns Invoices instance" do
      service.invoices.should be_an_instance_of(Blinksale::Invoices)
    end
    
    describe "Invoices instance" do
      let(:invoices) { service.invoices }

      it "has proper service set" do
        invoices.service.should eql(service)
      end
    end
  end

  describe "#clients" do
    it "returns Clients instance" do
      service.clients.should be_an_instance_of(Blinksale::Clients)
    end
  end
end
