require "spec_helper"

RSpec.describe StorageProxyClient do
  it "has a version number" do
    expect(StorageProxyClient::VERSION).not_to be nil
  end
end
