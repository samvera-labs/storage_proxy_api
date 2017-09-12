require 'spec_helper'
require 'storage_proxy_client/client'

describe StorageProxyClient::Response do

  let(:mock_faraday_response) do
    Faraday::Response.new(body: mock_response_body.to_json)
  end

  let(:mock_external_uri) { 'http://pretendvendor.org/123355' }
  let(:mock_vendor_service) { 'Pretend Vendor' }


  subject { described_class.new(faraday_response: mock_faraday_response) }

  describe 'staged?' do
    context 'when the response reports that the file is staged' do

      let(:mock_response_body) do
        {
          external_uri: mock_external_uri,
          service: mock_vendor_service,
          staged: '1',
          staged_location: 'yomomshouse://12345'
        }
      end

      it 'returns true' do
        expect(subject).to be_staged
      end
    end

    context 'when the response reports that the file is not staged' do

      let(:mock_response_body) do
        {
          external_uri: mock_external_uri,
          service: mock_vendor_service,
          staged: '0'
        }
      end

      it 'returns false' do
        expect(subject).to_not be_staged
      end
    end
  end
end