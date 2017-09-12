require 'storage_proxy_client/client'

describe StorageProxyClient::Client do

  subject { described_class.new }

  before do
    stub_request(:get, "http://localhost/status/#{example_uri}").
      to_return(status: expected_resp_status, body: expected_resp_body, headers: expected_resp_headers)
  end

  # Set defaults for the values used in the mocked request
  let(:endpoint) { Regexp.new('.*') }
  let(:expected_req_headers) { { } }
  let(:expected_resp_headers) { { } }
  let(:expected_resp_body) { '' }
  let(:expected_resp_status) { '500' }


  let(:example_uri) do
    URI.escape(['example_host:12234', 'http://example.org/12355'].sample)
  end

  describe '#status' do

    it 'returns a StorageProxyClient::Response object' do
      expect(subject.status(example_uri)).to be_a StorageProxyClient::Response
    end

    context 'when file is currently staged' do


      it 'returns a 200' do
        expect(subject.status(example_url).http_status).to eq 200
      end
    end

    context 'when file is not staged' do

    end

    context 'when you fucked up the request' do

    end

      # let(:endpoint) { /status/ }
      # let(:expected_req_headers)

  end
end