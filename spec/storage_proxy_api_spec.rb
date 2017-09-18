require "spec_helper"

RSpec.describe StorageProxyAPI do
  it "has a version number" do
    expect(StorageProxyAPI::VERSION).not_to be nil
  end
end
