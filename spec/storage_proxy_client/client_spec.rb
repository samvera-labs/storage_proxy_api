require 'spec_helper'
require 'storage_proxy_client/client'

describe StorageProxyClient::Client do

  let(:external_uri) { ['example_host:12234', 'http://example.org/12355'].sample }
  let(:fake_service) { "Example Service" }

  subject { described_class.new(external_uri: external_uri, service: fake_service) }

  before do
    stub_request(:get, "http://localhost/status/#{CGI.escape(external_uri)}").
      to_return(status: expected_resp_status, body: expected_resp_body, headers: expected_resp_headers)
  end

  # Set defaults for the values used in the mocked request
  let(:endpoint) { Regexp.new('.*') }
  let(:expected_req_headers) { { } }
  let(:expected_resp_headers) { { } }
  let(:expected_resp_body) { '' }
  let(:expected_resp_status) { '500' }


  describe '#status' do
    it 'returns a StorageProxyClient::Response object' do
      expect(subject.status).to be_a StorageProxyClient::Response
    end

    it 'sends a request to the "status" API endpoint with the correct headers' do
      status_uri = subject.send(:build_request_uri, :status)
      status_headers = subject.send(:build_request_headers)
      expect(subject.conn).to receive(:get).with(status_uri, nil, status_headers)
      expect(subject.status)
    end
  end

  describe '#stage'  do
    it 'returns a StorageProxyClient::Response object' do
      expect(subject.status).to be_a StorageProxyClient::Response
    end

    it 'sends a request to the "stage" API endpoint with the correct headers' do
      stage_uri = subject.send(:build_request_uri, :stage)
      stage_headers = subject.send(:build_request_headers)
      expect(subject.conn).to receive(:get).with(stage_uri, nil, stage_headers)
      expect(subject.stage)
    end
  end

  describe '.build_request_uri' do
    context 'for "stage" endpoint' do
      it 'returns the API uri to initiate a stage request' do
        expect(subject.send(:build_request_uri, :stage)).to eq "#{subject.config[:api_root]}/stage/#{CGI.escape(external_uri)}"
      end
    end

    context 'for "status" endpoint' do
      it 'returns the API uri to initiate a status request' do
        expect(subject.send(:build_request_uri, :status)).to eq "#{subject.config[:api_root]}/status/#{CGI.escape(external_uri)}"
      end
    end
  end

  describe '.build_request_headers' do
    it 'has a field for "service"' do
      expect(subject.send(:build_request_headers)).to have_key :service
    end

    it 'has a field for "events" when we tell it to' do
      expect(subject.send(:build_request_headers, include_events: true)).to have_key :events
    end
  end
end
